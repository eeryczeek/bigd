from uuid import UUID
from models import Seat, SeatReservation
from db.connection import session

create_reservation_query = session.prepare(
    query="""INSERT INTO seat_reservations (show_id, seat, user_mail) VALUES (?, ?, ?) IF NOT EXISTS"""
)

create_reservation_by_user = session.prepare(
    "INSERT INTO reservations_by_user (user_mail, show_id, seat) VALUES (?, ?, ?)"
)


get_reservation_query = session.prepare(
    "SELECT * FROM seat_reservations WHERE show_id = ?"
)

get_reservations_by_user_query = session.prepare(
    "SELECT * FROM reservations_by_user WHERE user_mail = ?"
)


def create_reservation(reservation: SeatReservation):
    res = session.execute(
        create_reservation_query,
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


get_all_reservations_query = session.prepare("SELECT * FROM seat_reservations")


def get_all_reservations():
    rows = session.execute(get_all_reservations_query).all()
    return [
        SeatReservation(
            show_id=row.show_id,
            seat=Seat(**row.seat._asdict()),
            user_mail=row.user_mail,
        )
        for row in rows
    ]


def get_reservations_for_user(user_mail):
    rows = session.execute(
        "SELECT * FROM reservations_by_user WHERE user_mail = ?", [user_mail]
    ).all()
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


def get_reservations_by_user(user_mail):
    rows = session.execute(get_reservations_by_user_query, [user_mail])
    return [SeatReservation(**row._asdict()) for row in rows]
