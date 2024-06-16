from pydantic import BaseModel
from typing import List
from uuid import UUID
from datetime import datetime


class User(BaseModel):
    email: str


class Movie(BaseModel):
    title: str
    duration: int = 0
    genres: List[str] = []
    rating: float = 0.0


class Seat(BaseModel):
    x: int
    y: int
    is_reserved: bool | None = None


class CinemaRoom(BaseModel):
    name: str
    seats: List[Seat]


class MovieShow(BaseModel):
    show_id: UUID
    movie_title: str
    room_name: str
    show_time: datetime


class SeatReservation(BaseModel):
    show_id: UUID
    seat: Seat
    user_mail: str
