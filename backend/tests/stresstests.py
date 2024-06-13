from locust import HttpUser, task, between, SequentialTaskSet

'''
python -m locust -f stresstests.py --headless -u 1 -r 1 --run-time 1m
'''


class UserBehavior(HttpUser):
    host = "http://localhost:8000"
    wait_time = between(0, 0)

    @task
    class StressTest1(SequentialTaskSet):
        @task
        def fetch_movies(self):
            self.client.get("/movies")

    @task
    class StressTest2(SequentialTaskSet):
        @task
        def fetch_movie_shows(self):
            movieTitle = "Inception"
            self.client.get(f"/shows/{movieTitle}")

        @task
        def fetch_cinema_room(self):
            cinemaRoomName = "Room 1"
            self.client.get(f"/rooms/{cinemaRoomName}")

    @task
    class StressTest3(SequentialTaskSet):
        @task
        def create_reservation(self):
            movieShow = self.client.get("/shows/Inception").json()[0]
            self.client.post(f"/reservations/{movieShow.show_id}", json={
                "show_id": movieShow['show_id'],
                "seat": {"x": 1, "y": 1, "is_reserved": True},
                "user_mail": "user@example.com"
            })

    @task
    class StressTest4(SequentialTaskSet):
        @task
        def fetch_reservations(self):
            self.client.get("/reservations/user@example.com")

    @task
    class StressTest5(SequentialTaskSet):
        @task
        def fetch_reservations_by_user(self):
            self.client.get("/reservations/user/user@example.com")
