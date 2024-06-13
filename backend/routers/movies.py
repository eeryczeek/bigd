from fastapi.routing import APIRouter
from fastapi.logger import logger
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
    movie = movies.create_movie(movie)
    print(f"Returned from creation of movie: {movie}")
    return movie


@router.delete("/{movie_title}")
def delete_movie(movie_title: str):
    return movies.delete_movie_by_title(movie_title)
