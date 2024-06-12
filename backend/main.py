from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routers import movies, rooms, shows, reservations

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


app.include_router(movies.router)
app.include_router(rooms.router)
app.include_router(shows.router)
app.include_router(reservations.router)
