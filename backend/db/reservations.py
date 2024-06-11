from ..models import SeatReservation, Seat, MovieShow
from .connection import session

create_reservation = session.prepare(
    query="""CONSISTENCY ALL;
    INSERT INTO seat_reservation (show_id, seat, user_mail) VALUES (?, ?, ?) IF NOT EXISTS"""
)
create_reservation_by_user = session.prepare(
    "INSERT INTO reservations_by_user (user_mail, show_id, seat) VALUES (?, ?, ?)"
)


def create_reservation_for_show(reservation: SeatReservation):
    # create a reservation for a seat, if successful add it to reservations by user
    session.execute(
        create_reservation,
        [
            reservation.show_uuid,
            reservation.seat,
            reservation.user,
        ],
    )
    session.execute(
        create_reservation_by_user,
        [
            reservation.user,
            reservation.show_uuid,
            reservation.seat.dict(),
        ],
    )
