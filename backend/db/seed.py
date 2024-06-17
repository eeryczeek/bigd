from datetime import datetime
from models import Movie, MovieShow, CinemaRoom, Seat, SeatReservation
from uuid import uuid4
from db.connection import session
from db.rooms import create_room
from db.movies import create_movie
from db.shows import create_show, get_shows, get_seats_for_show
from db.reservations import create_reservation


def insert_sample_data():
    room_names = ["Room " + str(i) for i in range(1, 4)]
    rows_by_columns_rooms = [(2, 3), (6, 4), (4, 5)]
    for room_name, (rows, columns) in zip(room_names, rows_by_columns_rooms):
        seats = [
            Seat(x=i, y=j, is_reserved=False)
            for i in range(rows)
            for j in range(columns)
        ]
        create_room(CinemaRoom(name=room_name, seats=seats))

    movies = [
        Movie(
            title="The Matrix", duration=120, genres=["Sci-Fi", "Action"], rating=8.7
        ),
        Movie(
            title="The Dark Knight",
            duration=152,
            genres=["Action", "Crime"],
            rating=9.0,
        ),
        Movie(
            title="Inception", duration=148, genres=["Action", "Adventure"], rating=8.8
        ),
    ]
    for movie in movies:
        create_movie(movie)

    shows = [
        MovieShow(
            show_id=uuid4(),
            movie_title="The Matrix",
            room_name="Room 1",
            show_time=datetime(2024, 7, 1, 18, 0),
        ),
        MovieShow(
            show_id=uuid4(),
            movie_title="The Matrix",
            room_name="Room 2",
            show_time=datetime(2024, 7, 1, 18, 0),
        ),
        MovieShow(
            show_id=uuid4(),
            movie_title="The Dark Knight",
            room_name="Room 2",
            show_time=datetime(2024, 7, 2, 18, 0),
        ),
        MovieShow(
            show_id=uuid4(),
            movie_title="Inception",
            room_name="Room 3",
            show_time=datetime(2024, 7, 3, 18, 0),
        ),
    ]
    for show in shows:
        create_show(show)

    shows = get_shows()
    seats = {show.show_id: get_seats_for_show(show.show_id) for show in shows}
    reservations = [
        SeatReservation(
            id=uuid4(),
            show_id=shows[0].show_id,
            seat=seats[shows[0].show_id][1].copy(update={"is_reserved": True}),
            user_mail="user@mail.com",
        ),
        SeatReservation(
            id=uuid4(),
            show_id=shows[1].show_id,
            seat=seats[shows[1].show_id][2].copy(update={"is_reserved": True}),
            user_mail="user2@mail.com",
        ),
        SeatReservation(
            id=uuid4(),
            show_id=shows[2].show_id,
            seat=seats[shows[2].show_id][3].copy(update={"is_reserved": True}),
            user_mail="user3@mail.com",
        ),
    ]

    for reservation in reservations:
        create_reservation(reservation)


def clean_up():
    session.execute("TRUNCATE cinema_rooms")
    session.execute("TRUNCATE movies")
    session.execute("TRUNCATE movie_shows_by_id")
    session.execute("TRUNCATE movie_shows_by_movie")
    session.execute("TRUNCATE seats_by_show")
    session.execute("TRUNCATE reservations")
    session.shutdown()
