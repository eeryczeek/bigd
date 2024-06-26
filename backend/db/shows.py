from datetime import datetime
from db.connection import session
from models import MovieShow, Seat
from db.rooms import get_room_by_name
import uuid

get_shows_by_movie_title_query = session.prepare(
    "SELECT * FROM movie_shows_by_movie WHERE movie_title = ?"
)
get_show_by_id_query = session.prepare(
    "SELECT * FROM movie_shows_by_id WHERE show_id = ?"
)


def get_show_by_movie(movie_title: str):
    rows = session.execute(get_shows_by_movie_title_query, [movie_title]).all()
    return [
        MovieShow(
            show_id=row.show_id,
            movie_title=row.movie_title,
            room_name=row.room_name,
            show_time=row.show_time,
        )
        for row in rows
    ]


get_all_shows_query = session.prepare("SELECT * FROM movie_shows_by_movie")


def get_shows():
    rows = session.execute(get_all_shows_query).all()
    return [
        MovieShow(
            show_id=row.show_id,
            movie_title=row.movie_title,
            room_name=row.room_name,
            show_time=row.show_time,
        )
        for row in rows
    ]


def get_show_by_id(show_uuid):
    row = session.execute(get_show_by_id_query, [show_uuid]).one()
    return MovieShow(
        show_id=row.show_id,
        movie_title=row.movie_title,
        room_name=row.room_name,
        show_time=row.show_time,
    )


get_seats_by_show = session.prepare(
    "SELECT * FROM seats_by_show WHERE show_id = ?")


def get_seats_for_show(show_uuid: uuid.UUID):
    rows = session.execute(get_seats_by_show, [show_uuid]).all()
    return [Seat(**row.seat._asdict(), is_reserved=row.is_reserved) for row in rows]


update_seat_query = session.prepare(
    query="UPDATE seats_by_show SET is_reserved = ? WHERE show_id = ? AND seat = ?"
)


def update_seat(show_uuid: uuid.UUID, seat: Seat):
    session.execute(update_seat_query, [seat.is_reserved, show_uuid, seat])


create_show_by_id = session.prepare(
    "INSERT INTO movie_shows_by_id (show_id, movie_title, room_name, show_time) VALUES (?, ?, ?, ?)"
)
create_show_by_movie = session.prepare(
    "INSERT INTO movie_shows_by_movie (show_id, movie_title, room_name, show_time) VALUES (?, ?, ?, ?)"
)
create_seat = session.prepare(
    "INSERT INTO seats_by_show (show_id, seat, is_reserved) VALUES (?, ?, false)"
)


def create_show(show: MovieShow):
    new_show_id = uuid.uuid4()
    room = get_room_by_name(show.room_name)
    session.execute(
        create_show_by_id,
        [
            new_show_id,
            show.movie_title,
            show.room_name,
            show.show_time,
        ],
    )
    session.execute(
        create_show_by_movie,
        [
            new_show_id,
            show.movie_title,
            show.room_name,
            show.show_time,
        ],
    )
    for seat in room.seats:
        seat.is_reserved = False
        session.execute(
            create_seat,
            [new_show_id, seat],
        )


delete_show_by_id = session.prepare(
    "DELETE FROM movie_shows_by_id WHERE show_id = ?")


delete_show_by_movie_id = session.prepare(
    "DELETE FROM movie_shows_by_movie WHERE movie_title = ? AND show_time = ? AND show_id = ?"
)


def delete_show(show_uuid):
    show = get_show_by_id(show_uuid)
    session.execute(delete_show_by_id, [show_uuid])
    session.execute(
        delete_show_by_movie_id, [
            show.movie_title, show.show_time, show.show_id]
    )
