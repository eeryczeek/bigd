from typing import List
from db.connection import session
from models import CinemaRoom, Seat

get_room = session.prepare("SELECT * FROM cinema_rooms WHERE name = ?")
get_rooms_query = session.prepare("SELECT * FROM cinema_rooms")


def get_room_by_name(name: str) -> CinemaRoom:
    row = session.execute(get_room, [name]).one()
    return CinemaRoom(
        name=row.name, seats=[Seat(**seat._asdict()) for seat in row.seats]
    )


def get_rooms() -> List[CinemaRoom]:
    rows = session.execute(get_rooms_query).all()
    return [
        CinemaRoom(name=row.name, seats=[Seat(**seat._asdict()) for seat in row.seats])
        for row in rows
    ]


create_room_query = session.prepare(
    "INSERT INTO cinema_rooms (name, seats) VALUES (?, ?)"
)


def create_room(new_room: CinemaRoom):
    return session.execute(create_room_query, [new_room.name, new_room.seats])


delete_room = session.prepare("DELETE FROM cinema_rooms WHERE name = ?")


def delete_room_by_name(name: str):
    return session.execute(delete_room, [name])
