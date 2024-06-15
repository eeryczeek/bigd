from uuid import UUID
from fastapi.routing import APIRouter
import db.reservations as reservations
from models import SeatReservation

router = APIRouter(prefix="/reservations", tags=["reservations"])


@router.get("/")
def get_all_reservations():
    return reservations.get_all_reservations()


@router.get("/{show_uuid}")
def get_reservations(show_uuid: UUID):
    return reservations.get_reservations_for_show(show_uuid)


@router.get("/user/{user_mail}")
def get_reservations_by_user(user_mail: str):
    return reservations.get_reservations_for_user(user_mail)


@router.delete("/{show_uuid}")
def delete_reservation(show_uuid: UUID, seat: SeatReservation):
    return reservations.delete_reservation_for_show(show_uuid, seat)


@router.post("/{show_uuid}")
def add_reservation(reservation: SeatReservation):
    return reservations.create_reservation_for_show(reservation)
