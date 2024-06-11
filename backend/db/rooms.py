from typing import List
from .connection import session
from ..models import CinemaRoom, Seat

get_room = session.prepare("SELECT * FROM cinema_room WHERE name = ?")


def get_room_by_name(name: str) -> CinemaRoom:
    row = session.execute(get_room, [name]).one()
    return CinemaRoom(name=row.name, seats=[Seat(seat._asdict()) for seat in row.seats])


create_room_query = session.prepare(
    "INSERT INTO cinema_room (name, seats) VALUES (?, ?)"
)


def create_room(new_room: CinemaRoom):
    session.execute(create_room_query, [new_room.name, new_room.seats])


delete_room = session.prepare("DELETE FROM cinema_room WHERE name = ?")


def delete_room_by_name(name: str):
    session.execute(delete_room, [name])
    return None
