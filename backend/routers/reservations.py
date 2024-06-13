from uuid import UUID
from fastapi.routing import APIRouter
import db.reservations as reservations
from models import SeatReservation, Seat

router = APIRouter(prefix="/reservations", tags=["reservations"])


@router.get("/{show_uuid}")
def get_reservations(show_uuid: UUID):
    return reservations.get_reservations_for_show(show_uuid)


@router.post("/{show_uuid}")
def add_reservation(reservation: SeatReservation):
    return reservations.create_reservation_for_show(reservation)


@router.put("/{show_uuid}")
def update_reservation(reservation: SeatReservation):
    return reservations.update_reservation(reservation)


@router.delete("/{show_uuid}")
def delete_reservation(show_uuid: UUID, seat: Seat):
    return reservations.delete_reservation_for_show(show_uuid, seat)
