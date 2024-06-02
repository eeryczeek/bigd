from fastapi import FastAPI
from cassandra.cluster import Cluster
from pydantic import BaseModel
from typing import List

app = FastAPI()
cluster = Cluster()
session = cluster.connect("test_keyspace")

class Movie(BaseModel):
    title: str
    duration: int
    genres: List[str]
    rating: float

class Time(BaseModel):
    time: str

class Seat(BaseModel):
    seat: str

class SeatList(BaseModel):
    seats: List[str]

@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.get("/movies")
def read_movies():
    rows = session.execute("SELECT * FROM movies")
    return {"movies": [row.movie for row in rows]}

@app.post("/movies")
def create_movie(movie: str):
    session.execute(f"INSERT INTO movies (movie) VALUES ('{movie}')")
    return {"movie": movie}

@app.get("/movies/{movie_id}/timetable")
def read_movie_timetable(movie_id: int):
    rows = session.execute(f"SELECT * FROM timetable WHERE movie_id={movie_id}")
    return {"timetable": [row.time for row in rows]}

@app.post("/movies/{movie_id}/timetable")
def create_movie_timetable(movie_id: int, time: str):
    session.execute(f"INSERT INTO timetable (movie_id, time) VALUES ({movie_id}, '{time}')")
    return {"time": time}

@app.get("/movies/{movie_id}/timetable/{time}/seats")
def read_movie_timetable_seats(movie_id: int, time: str):
    rows = session.execute(f"SELECT * FROM seats WHERE movie_id={movie_id} AND time='{time}'")
    return {"seats": [row.seat for row in rows]}

@app.post("/movies/{movie_id}/timetable/{time}/seats")
def create_movie_timetable_seats(movie_id: int, time: str, seat: str):
    session.execute(f"INSERT INTO seats (movie_id, time, seat) VALUES ({movie_id}, '{time}', '{seat}')")
    return {"seat": seat}

@app.put("/movies/{movie_id}/timetable/{time}/seats")
def reserve_seats(movie_id: int, time: str, seats: SeatList):
    for seat in seats:
        session.execute(f"UPDATE seats SET reserved=true WHERE movie_id={movie_id} AND time='{time}' AND seat='{seat}'")
    return {"seats": seats}

