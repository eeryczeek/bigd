from pydantic import BaseModel
from typing import List
from uuid import UUID
from datetime import datetime


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


class CinemaRoom(BaseModel):
    uuid: UUID
    name: str
    seats: List[Seat]


class MovieShow(BaseModel):
    uuid: UUID
    movie_uuid: UUID
    cinema_room_uuid: UUID
    show_time: datetime


class SeatReservation(BaseModel):
    cinema_room_uuid: UUID
    show_time: datetime
    seat_uuid: UUID
    user_id: UUID
