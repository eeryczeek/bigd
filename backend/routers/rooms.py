from fastapi.routing import APIRouter
import db.rooms as rooms
from models import CinemaRoom

router = APIRouter(prefix="/rooms", tags=["rooms"])


@router.get("/{cinema_room_name}")
def get_cinema_room(cinema_room_name: str):
    return rooms.get_room_by_name(cinema_room_name)


@router.post("")
def add_cinema_room(cinema_room: CinemaRoom):
    return rooms.create_room(cinema_room)


@router.delete("/{cinema_room_name}")
def delete_cinema_room(cinema_room_name: str):
    return rooms.delete_room_by_name(cinema_room_name)
