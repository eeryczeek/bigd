from fastapi import FastAPI
from uuid import UUID, uuid4
from typing import List
from datetime import datetime


from models import Movie, CinemaRoom, MovieShow, SeatReservation
from database import session

app = FastAPI()


@app.post("/movies/", response_model=Movie)
async def create_movie(movie: Movie):
    query = "INSERT INTO movies (uuid, title, duration, genres, rating) VALUES (?, ?, ?, ?, ?)"
    session.execute(query, (movie.uuid, movie.title,
                    movie.duration, movie.genres, movie.rating))
    return movie


@app.get("/movies/", response_model=List[Movie])
async def read_movies():
    rows = session.execute("SELECT * FROM movies")
    movies = [Movie(**row._asdict()) for row in rows]
    return movies


@app.post("/cinema_rooms/", response_model=CinemaRoom)
async def create_cinema_room(cinema_room: CinemaRoom):
    query = "INSERT INTO cinema_rooms (uuid, name, seats) VALUES (?, ?, ?)"
    session.execute(
        query, (cinema_room.uuid, cinema_room.name, cinema_room.seats))
    return cinema_room


@app.get("/cinema_rooms/", response_model=List[CinemaRoom])
async def read_cinema_rooms():
    rows = session.execute("SELECT * FROM cinema_rooms")
    cinema_rooms = [CinemaRoom(**row._asdict()) for row in rows]
    return cinema_rooms


@app.post("/movie_shows/", response_model=MovieShow)
async def create_movie_show(movie_show: MovieShow):
    query = "INSERT INTO movie_shows (uuid, movie_uuid, cinema_room_uuid, show_time) VALUES (?, ?, ?, ?)"
    session.execute(query, (movie_show.uuid, movie_show.movie_uuid,
                    movie_show.cinema_room_uuid, movie_show.show_time))
    return movie_show


@app.get("/movie_shows/", response_model=List[MovieShow])
async def read_movie_shows():
    rows = session.execute("SELECT * FROM movie_shows")
    movie_shows = [MovieShow(**row._asdict()) for row in rows]
    return movie_shows


@app.post("/seat_reservations/", response_model=SeatReservation)
async def reserve_seat(seat_reservation: SeatReservation):
    query = "INSERT INTO seat_reservations (cinema_room_uuid, show_time, seat_uuid, user_id) VALUES (?, ?, ?, ?)"
    session.execute(query, (seat_reservation.cinema_room_uuid, seat_reservation.show_time,
                    seat_reservation.seat_uuid, seat_reservation.user_id))
    return seat_reservation


@app.get("/seat_reservations/", response_model=List[SeatReservation])
async def read_seat_reservations(cinema_room_uuid: UUID, show_time: datetime):
    query = "SELECT * FROM seat_reservations WHERE cinema_room_uuid = ? AND show_time = ?"
    rows = session.execute(query, (cinema_room_uuid, show_time))
    seat_reservations = [SeatReservation(**row._asdict()) for row in rows]
    return seat_reservations
