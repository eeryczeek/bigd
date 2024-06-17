from locust import HttpUser, task, between, SequentialTaskSet, TaskSet, events
from locust.env import Environment
from locust.stats import stats_printer, stats_history
from locust.log import setup_logging
import gevent


class StressTest2(TaskSet):
    @ task
    def fetch_movie_shows(self):
        for _ in range(3333):
            movieTitle = "Inception"
            self.client.get(f"/shows/{movieTitle}")

    @ task
    def fetch_reservations(self):
        for _ in range(3333):
            self.client.get("/reservations")

    @ task
    def fetch_cinema_room(self):
        for _ in range(3333):
            cinemaRoomName = "Room 1"
            self.client.get(f"/rooms/{cinemaRoomName}")


class UserBehavior(HttpUser):
    host = "http://localhost:8000"
    wait_time = between(0, 0)
    tasks = [StressTest2]


def main():
    setup_logging("INFO", None)

    env = Environment(user_classes=[UserBehavior])
    env.create_local_runner()

    gevent.spawn(stats_printer(env.stats))
    gevent.spawn(stats_history, env.runner)

    env.runner.start(user_count=5, spawn_rate=1)

    gevent.spawn_later(60, lambda: env.runner.quit())
    env.runner.greenlet.join()


if __name__ == "__main__":
    main()
