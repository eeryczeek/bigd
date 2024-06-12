from pydantic import BaseModel
from typing import List
from uuid import UUID
from datetime import datetime


class User(BaseModel):
    email: str


class Movie(BaseModel):
    title: str
    duration: int
    genres: List[str]
    rating: float


class Seat(BaseModel):
    x: int
    y: int
    is_reserved: bool | None


class CinemaRoom(BaseModel):
    name: str
    seats: List[Seat]


class MovieShow(BaseModel):
    uuid: UUID
    movie: str
    room: str
    show_time: datetime


class SeatReservation(BaseModel):
    show_uuid: UUID
    seat: Seat
    user: str
