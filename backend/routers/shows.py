from fastapi.routing import APIRouter
import db.shows as shows
from models import MovieShow
from uuid import UUID

router = APIRouter(prefix="/shows", tags=["shows"])


@router.get("/")
def get_all_shows():
    return shows.get_shows()


@router.get("/{movie_title}")
def get_shows(movie_title: str):
    return shows.get_show_by_movie(movie_title)


@router.get("/{show_uuid}")
def get_show(show_uuid: UUID):
    return shows.get_show_by_id(show_uuid)


@router.get("/{show_uuid}/seats")
def get_seats(show_uuid: UUID):
    return shows.get_seats_for_show(show_uuid)


@router.post("/")
def add_show(show: MovieShow):
    return shows.create_show(show)


@router.delete("/{show_uuid}")
def delete_show(show_uuid: UUID):
    return shows.delete_show(show_uuid)
