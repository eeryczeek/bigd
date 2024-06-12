from fastapi import FastAPI
from contextlib import asynccontextmanager
from fastapi.middleware.cors import CORSMiddleware
from routers import movies, rooms, shows, reservations
from db import seed


@asynccontextmanager
async def lifespan(app: FastAPI):
    seed.insert_sample_data()
    yield
    seed.clean_up()


app = FastAPI(lifespan=lifespan)


app.include_router(movies.router)
app.include_router(rooms.router)
app.include_router(shows.router)
app.include_router(reservations.router)
