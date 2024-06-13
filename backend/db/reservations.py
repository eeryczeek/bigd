from uuid import UUID
from models import Seat, SeatReservation
from db.connection import session
from db.shows import update_seats_by_show

create_reservation = session.prepare(
    query="""INSERT INTO seat_reservations (show_id, seat, user_mail) VALUES (?, ?, ?) IF NOT EXISTS"""
)

create_reservation_by_user = session.prepare(
    "INSERT INTO reservations_by_user (user_mail, show_id, seat) VALUES (?, ?, ?)"
)


def create_reservation_for_show(reservation: SeatReservation):
    res = session.execute(
        create_reservation,
        [
            reservation.show_id,
            reservation.seat,
            reservation.user_mail,
        ],
    )
    if res.one().was_applied:
        session.execute(
            create_reservation_by_user,
            [
                reservation.user_mail,
                reservation.show_id,
                reservation.seat,
            ],
        )
        reservation.seat.is_reserved = True
        update_seats_by_show(reservation.show_id, reservation.seat)


get_reservation_query = session.prepare(
    "SELECT * FROM seat_reservations WHERE show_id = ?"
)


def get_reservations_for_show(show_uuid):
    rows = session.execute(get_reservation_query, [show_uuid]).all()
    return [
        SeatReservation(
            show_id=row.show_id,
            seat=Seat(**row.seat._asdict()),
            user_mail=row.user_mail,
        )
        for row in rows
    ]


delete_reservation_query = session.prepare(
    query="DELETE FROM seat_reservations WHERE show_id = ? AND seat = ?"
)


def delete_reservation_for_show(show_uuid: UUID, seat: Seat):
    return session.execute(delete_reservation_query, [show_uuid, seat])


def update_reservation(reservation: SeatReservation):
    pass


def get_reservations_by_user(user_mail):
    pass


def delete_reservation_by_user(user_mail, show_id, seat):
    pass
