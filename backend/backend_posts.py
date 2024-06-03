from fastapi import FastAPI, HTTPException
from models import User, Movie, CinemaRoom, MovieShow, SeatReservation
import database as db

app = FastAPI()


@app.post("/users/")
async def create_user(user: User):
    try:
        created_user = db.create_user(user)
        return created_user
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.post("/movies/")
async def create_movie(movie: Movie):
    try:
        created_movie = db.create_movie(movie)
        return created_movie
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.post("/cinema_rooms/")
async def create_cinema_room(cinema_room: CinemaRoom):
    try:
        created_room = db.create_cinema_room(cinema_room)
        return created_room
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.post("/movie_shows/")
async def create_movie_show(movie_show: MovieShow):
    try:
        created_show = db.create_movie_show(movie_show)
        return created_show
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.post("/seat_reservations/")
async def reserve_seat(seat_reservation: SeatReservation):
    try:
        created_reservation = db.reserve_seat(seat_reservation)
        return created_reservation
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
