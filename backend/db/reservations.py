from uuid import UUID
from models import Seat, SeatReservation
from db.connection import session

create_reservation = session.prepare(
    query="""INSERT INTO seat_reservations (show_id, seat, user_mail) VALUES (?, ?, ?) IF NOT EXISTS"""
)

create_reservation_by_user = session.prepare(
    "INSERT INTO reservations_by_user (user_mail, show_id, seat) VALUES (?, ?, ?)"
)


def create_reservation_for_show(reservation: SeatReservation):
    session.execute(
        create_reservation,
        [
            reservation.show_id,
            reservation.seat,
            reservation.user_mail,
        ],
    )


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
        "SELECT * FROM reservations_by_user WHERE user_mail = ?", [user_mail]).all()
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
