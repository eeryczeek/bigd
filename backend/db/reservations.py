from typing import Tuple
from uuid import UUID, uuid4
from models import Seat, SeatReservation
from db.connection import session
from db.shows import update_seat

create_reservation_query = session.prepare(
    query="""INSERT INTO reservations (id, show_id, seat, user_mail) VALUES (?, ?, ?, ?) IF NOT EXISTS""",
)

get_reservation_query = session.prepare("SELECT * FROM reservations WHERE show_id = ?")

get_reservations_by_user_query = session.prepare(
    "SELECT * FROM reservations WHERE user_mail = ?"
)

get_reservation_by_show_and_seat_query = session.prepare(
    "SELECT * FROM reservations WHERE show_id = ? AND seat = ?"
)


def create_reservation(reservation: SeatReservation):
    new_reservation_id = uuid4()
    res = session.execute(
        create_reservation_query,
        [
            new_reservation_id,
            reservation.show_id,
            reservation.seat,
            reservation.user_mail,
        ],
        timeout=10,
    )
    if not res.was_applied:
        return False
    update_seat(reservation.show_id, reservation.seat)
    return True


def get_reservations_for_show(show_uuid):
    rows = session.execute(get_reservation_query, [show_uuid]).all()
    return [
        SeatReservation(
            id=row.id,
            show_id=row.show_id,
            seat=Seat(**row.seat._asdict()),
            user_mail=row.user_mail,
        )
        for row in rows
    ]


get_reservation_by_id_query = session.prepare(
    query="SELECT * FROM reservations WHERE id = ?"
)


def get_reservation_by_id(reservation_id: UUID) -> SeatReservation | None:
    row = session.execute(get_reservation_by_id_query, [reservation_id]).one()
    if not row:
        return None
    return SeatReservation(
        id=row.id,
        show_id=row.show_id,
        seat=Seat(**row.seat._asdict()),
        user_mail=row.user_mail,
    )


def get_reservation_by_show_and_seat(
    show_id: UUID, seat: Seat
) -> SeatReservation | None:
    row = session.execute(get_reservation_by_show_and_seat_query, [show_id, seat]).one()
    if not row:
        return None
    return SeatReservation(
        id=row.id,
        show_id=row.show_id,
        seat=Seat(**row.seat._asdict(), is_reserved=True),
        user_mail=row.user_mail,
    )


get_all_reservations_query = session.prepare("SELECT * FROM reservations")


def get_all_reservations():
    rows = session.execute(get_all_reservations_query).all()
    return [
        SeatReservation(
            id=row.id,
            show_id=row.show_id,
            seat=Seat(**row.seat._asdict(), is_reserved=True),
            user_mail=row.user_mail,
        )
        for row in rows
    ]


reservations_by_user_query = session.prepare(
    query="SELECT * FROM reservations WHERE user_mail = ?"
)


get_reservations_by_user_query = session.prepare(
    query="SELECT * FROM reservations WHERE user_mail = ?"
)


def get_reservations_for_user(user_mail):
    rows = session.execute(get_reservations_by_user_query, [user_mail]).all()
    return [
        SeatReservation(
            id=row.id,
            show_id=row.show_id,
            seat=Seat(**row.seat._asdict()),
            user_mail=row.user_mail,
        )
        for row in rows
    ]


delete_reservation_query = session.prepare(
    query="DELETE FROM reservations WHERE show_id = ? AND seat = ?"
)


def delete_reservation(reseravation_uuid: UUID):
    reservation = get_reservation_by_id(reseravation_uuid)
    print(reservation)
    if reservation is None:
        return False
    session.execute(delete_reservation_query, [reservation.show_id, reservation.seat])
    seat = reservation.seat.copy(update={"is_reserved": False})
    update_seat(reservation.show_id, seat)
    return True


def get_reservations_by_user(user_mail):
    rows = session.execute(get_reservations_by_user_query, [user_mail])
    return [SeatReservation(**row._asdict()) for row in rows]


update_reservation_query = session.prepare(
    query="UPDATE reservations SET user_mail = ? WHERE show_id = ? AND seat = ? IF EXISTS"
)


def update_reservation(
    previous_reservation_uuid: UUID, new_reservation: SeatReservation
) -> Tuple[bool, str | None]:
    previous_reservation = get_reservation_by_id(previous_reservation_uuid)
    if not previous_reservation:
        return False, "Reservation not found"
    res = session.execute(
        update_reservation_query,
        [new_reservation.user_mail, new_reservation.show_id, new_reservation.seat],
    )
    if res.was_applied:
        return True, None
    return False, "Seat already reserved"
