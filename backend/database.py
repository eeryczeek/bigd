from cassandra.cluster import Cluster
from cassandra.query import SimpleStatement
import uuid
from datetime import datetime

from models import User, Movie, CinemaRoom, Seat, MovieShow, SeatReservation

cluster = Cluster(contact_points=["127.0.0.1"], port=9042)
session = cluster.connect("cinema")

# Prepared statements
insert_user = session.prepare(
    """
    INSERT INTO users (user_id, name, email)
    VALUES (?, ?, ?)
    """
)

select_user_by_id = session.prepare(
    """
    SELECT * FROM users WHERE user_id = ?
    """
)

select_user_by_email = session.prepare(
    """
    SELECT * FROM users WHERE email = ?
    """
)

insert_movie = session.prepare(
    """
    INSERT INTO movies (movie_id, title, duration, genres, rating)
    VALUES (?, ?, ?, ?, ?)
    """
)

list_movies = session.prepare(query="SELECT * FROM movies")

select_movie_by_title = session.prepare(query="SELECT * FROM movies WHERE title = ?")

insert_cinema_room = session.prepare(
    """
    INSERT INTO cinema_rooms (room_id, name)
    VALUES (?, ?)
    """
)

insert_seat = session.prepare(
    """
    INSERT INTO seats (seat_id, room_id, x, y)
    VALUES (?, ?, ?, ?)
    """
)

list_seats_by_room = session.prepare(query="SELECT * FROM seats WHERE room_id = ?")

insert_movie_show = session.prepare(
    """
    INSERT INTO movie_shows (show_id, movie_id, cinema_room_id, show_time)
    VALUES (?, ?, ?, ?)
    """
)

list_movie_shows_by_movie_id = session.prepare(
    """
    SELECT * FROM movie_shows WHERE movie_id = ?
    """
)

list_seats_for_the_show = session.prepare(
    query="SELECT * FROM seats_by_show WHERE show_id = ?"
)

update_seats_for_show = session.prepare(
    query="UPDATE seats_by_show SET available = ? WHERE show_id = ? AND seat_id = ?"
)

insert_seats_for_show = session.prepare(
    query="INSERT INTO seats_by_show (show_id, seat_id, available) VALUES (?, ?, ?)"
)

insert_seat_reservation = session.prepare(
    """
    INSERT INTO seat_reservations (cinema_room_id, show_id, seat_id, user_id)
    VALUES (?, ?, ?, ?)
    IF NOT EXISTS
    """
)


# Functions using models
def create_user(user: User):
    user_id = uuid.uuid4()
    session.execute(insert_user, (user_id, user.name, user.email))
    user.uuid = user_id
    return user


def create_movie(movie: Movie):
    movie_id = uuid.uuid4()
    session.execute(
        insert_movie,
        (movie_id, movie.title, movie.duration, movie.genres, movie.rating),
    )
    movie.uuid = movie_id
    return movie


def get_movies():
    rows = session.execute(list_movies)
    return [Movie(**row._asdict()) for row in rows]


def get_movie_by_title(title: str):
    rows = session.execute(select_movie_by_title, (title,))
    return [Movie(**row._asdict()) for row in rows]


def get_movie_shows_by_movie_id(movie_id: uuid.UUID):
    shows = session.execute(list_movie_shows_by_movie_id, (movie_id,))
    shows = [show._asdict() for show in shows]
    for show in shows:
        seats = session.execute(list_seats_for_the_show, (show.show_id,))
        show["seats"] = [Seat(**seat._asdict()) for seat in seats]
    return [MovieShow(**show._asdict()) for show in shows]


def create_cinema_room(cinema_room: CinemaRoom):
    room_id = uuid.uuid4()
    session.execute(insert_cinema_room, (room_id, cinema_room.name))
    for seat in cinema_room.seats:
        create_seat(room_id, seat)
    cinema_room.uuid = room_id
    return cinema_room


def create_seat(room_id, seat: Seat):
    seat_id = uuid.uuid4()
    session.execute(insert_seat, (seat_id, room_id, seat.x, seat.y))
    seat.uuid = seat_id
    return seat


def create_movie_show(movie_show: MovieShow):
    show_id = uuid.uuid4()
    session.execute(
        insert_movie_show,
        (
            show_id,
            movie_show.movie_uuid,
            movie_show.cinema_room_uuid,
            movie_show.show_time,
        ),
    )
    if movie_show.seats:
        for seat in movie_show.seats:
            session.execute(
                insert_seats_for_show, (show_id, seat.uuid, seat.is_reserved or True)
            )
    else:
        seats = session.execute(list_seats_by_room, (MovieShow.cinema_room_uuid,))
        movie_show.seats = [Seat(**seat._asdict()) for seat in seats]

    movie_show.uuid = show_id
    return movie_show


def reserve_seat(seat_reservation: SeatReservation):
    session.execute(
        insert_seat_reservation,
        (
            seat_reservation.cinema_room_uuid,
            seat_reservation.show_uuid,
            seat_reservation.seat_uuid,
            seat_reservation.user_id,
        ),
    )
    session.execute(
        update_seats_for_show,
        (False, seat_reservation.show_uuid, seat_reservation.seat_uuid),
    )
    return seat_reservation
