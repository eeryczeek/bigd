from .connection import session
from ..models import MovieShow, Seat
import uuid

get_shows_by_id = session.prepare("SELECT * FROM movie_show_by_id WHERE movie_uuid = ?")
get_seats_by_show = session.prepare("SELECT * FROM seats_by_show WHERE show_uuid = ?")


def get_show_by_uuid(show_uuid):
    rows = session.execute(get_shows_by_id, [show_uuid])
    seats_rows = session.execute(get_seats_by_show, [show_uuid])
    seats = [Seat(row._asdict()) for row in seats_rows]
    for row in rows:
        return MovieShow(
            uuid=row.uuid,
            movie_uuid=row.movie_uuid,
            cinema_room_uuid=row.cinema_room_uuid,
            room_name=row.room_name,
            seats=seats,
            show_time=row.show_time,
        )
    return None


get_shows_by_movie_uuid = session.prepare(
    "SELECT * FROM movie_show_by_movie_id WHERE movie_uuid = ?"
)


def get_show_by_movie_uuid(movie_uuid):
    rows = session.execute(get_shows_by_movie_uuid, [movie_uuid])
    seats_rows = session.execute(get_seats_by_show, [movie_uuid])
    seats = [Seat(row._asdict()) for row in seats_rows]
    return [MovieShow(row._asdict(), seats=seats) for row in rows]


create_show_by_id = session.prepare(
    "INSERT INTO movie_show_by_id (uuid, movie_uuid, cinema_room_uuid, room_name, show_time) VALUES (?, ?, ?, ?, ?)"
)
create_show_by_movie_id = session.prepare(
    "INSERT INTO movie_show_by_movie_id (uuid, movie_uuid, cinema_room_uuid, room_name, show_time) VALUES (?, ?, ?, ?, ?)"
)
create_seat = session.prepare(
    "INSERT INTO seats_by_show (show_uuid, seat_uuid, x, y, is_reserved) VALUES (?, ?, ?, ?, ?)"
)


def create_show(show: MovieShow):
    new_show_id = uuid.uuid4()
    session.execute(
        create_show,
        [
            new_show_id,
            show.movie_uuid,
            show.cinema_room_uuid,
            show.room_name,
            show.show_time,
        ],
    )
    session.execute(
        create_show_by_movie_id,
        [
            new_show_id,
            show.movie_uuid,
            show.cinema_room_uuid,
            show.room_name,
            show.show_time,
        ],
    )
    for seat in show.seats:
        session.execute(
            create_seat,
            [
                seat.uuid,
                new_show_id,
                seat.x,
                seat.y,
                seat.is_reserved or False,
            ],
        )

delete_show_by_id = session.prepare("DELETE FROM movie_show_by_id WHERE uuid = ?")
delete_show_by_movie_id = session.prepare("DELETE FROM movie_show_by_movie_id WHERE uuid = ?")

def delete_show(show_uuid):
