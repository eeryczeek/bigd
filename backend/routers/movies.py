from fastapi.routing import APIRouter
import db.movies as movies
from models import Movie

router = APIRouter(prefix="/movies", tags=["movies"])


@router.get("/", response_model=list[Movie])
def get_movies():
    return movies.get_movies()


@router.get("/{movie_title}", response_model=Movie)
def get_movie(movie_title: str):
    return movies.get_movie_by_title(movie_title)


@router.post("/")
def add_movie(movie: Movie):
    return movies.create_movie(movie)


@router.delete("/{movie_title}")
def delete_movie(movie_title: str):
    return movies.delete_movie_by_title(movie_title)
