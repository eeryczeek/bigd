from pydantic import BaseModel
from typing import List
from uuid import UUID
from datetime import datetime


class User(BaseModel):
    uuid: UUID
    name: str
    email: str


class Movie(BaseModel):
    uuid: UUID
    title: str
    duration: int
    genres: List[str]
    rating: float


class Seat(BaseModel):
    uuid: UUID
    x: int
    y: int
    is_reserved: bool | None


class CinemaRoom(BaseModel):
    uuid: UUID
    name: str
    seats: List[Seat]


class MovieShow(BaseModel):
    uuid: UUID
    movie_uuid: UUID
    cinema_room_uuid: UUID
    room_name: str
    seats: List[Seat]
    show_time: datetime


class SeatReservation(BaseModel):
    cinema_room_uuid: UUID
    show_uuid: UUID
    seat_uuid: UUID
    user_id: UUID
