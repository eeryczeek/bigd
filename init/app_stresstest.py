# locustfile.py
from locust import HttpUser, TaskSet, task, between
import uuid

class CinemaTasks(TaskSet):
    @task
    def create_reservation(self):
        reservation = {
            "user_id": str(uuid.uuid4()),
            "movie_id": str(uuid.uuid4()),
            "seat_number": "A1",
            "reservation_date": "2024-06-01T10:00:00Z",
            "status": "Booked"
        }
        self.client.post("/reservations/", json=reservation)

    @task
    def get_reservation(self):
        self.client.get("/reservations/1")

    @task
    def update_reservation(self):
        reservation = {
            "user_id": str(uuid.uuid4()),
            "movie_id": str(uuid.uuid4()),
            "seat_number": "A1",
            "reservation_date": "2024-06-01T10:00:00Z",
            "status": "Booked"
        }
        self.client.put("/reservations/1", json=reservation)

    @task
    def delete_reservation(self):
        self.client.delete("/reservations/1")

class CinemaUser(HttpUser):
    tasks = [CinemaTasks]
    wait_time = between(1, 5)
