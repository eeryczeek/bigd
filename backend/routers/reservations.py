from uuid import UUID
from fastapi import status, HTTPException
from fastapi.routing import APIRouter
import db.reservations as reservations
from models import SeatReservation

router = APIRouter(prefix="/reservations", tags=["reservations"])


@router.get("/", response_model=list[SeatReservation])
def get_all_reservations():
    return reservations.get_all_reservations()


@router.get("/show/{show_uuid}", response_model=list[SeatReservation])
def get_reservations(show_uuid: UUID):
    return reservations.get_reservations_for_show(show_uuid)


@router.get("/user/{user_mail}", response_model=list[SeatReservation])
def get_reservations_by_user(user_mail: str):
    return reservations.get_reservations_for_user(user_mail)


@router.get("/{reservation_uuid}", response_model=SeatReservation)
def get_reservation(reservation_uuid: UUID):
    res = reservations.get_reservation_by_id(reservation_uuid)
    if res:
        return res
    raise HTTPException(
        status_code=status.HTTP_404_NOT_FOUND, detail="Reservation not found"
    )


@router.delete("/{reservation_uuid}")
def delete_reservation(reservation_uuid: UUID):
    return reservations.delete_reservation(reservation_uuid)


@router.post("/{show_uuid}", status_code=status.HTTP_201_CREATED)
def add_reservation(reservation: SeatReservation):
    res = reservations.create_reservation(reservation)
    if not res:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST, detail="Seat already reserved"
        )


@router.put("/{previous_reservation_uuid}")
def update_reservation(
    previous_reservation_uuid: UUID, new_reservation: SeatReservation
):
    res, msg = reservations.update_reservation(
        previous_reservation_uuid, new_reservation
    )
    if not res:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=msg)
    return {"detail": "Reservation updated"}
