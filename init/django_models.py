# models.py
from cassandra.cqlengine import columns
from django_cassandra_engine.models import DjangoCassandraModel

class Reservation(DjangoCassandraModel):
    reservation_id = columns.UUID(primary_key=True)
    user_id = columns.UUID()
    movie_id = columns.UUID()
    seat_number = columns.Text()
    reservation_date = columns.DateTime()
    status = columns.Text()

class User(DjangoCassandraModel):
    user_id = columns.UUID(primary_key=True)
    name = columns.Text()
    email = columns.Text()

class Movie(DjangoCassandraModel):
    movie_id = columns.UUID(primary_key=True)
    movie_name = columns.Text()
    show_times = columns.List(columns.DateTime())
