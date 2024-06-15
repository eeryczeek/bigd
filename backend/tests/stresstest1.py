from locust import HttpUser, task, between, SequentialTaskSet, TaskSet, events
from locust.env import Environment
from locust.stats import stats_printer, stats_history
from locust.log import setup_logging
import gevent


class StressTest1(SequentialTaskSet):
    @ task
    def fetch_movies(self):
        for _ in range(10000):
            self.client.get("/movies")


class UserBehavior(HttpUser):
    host = "http://localhost:8000"
    wait_time = between(0, 0)
    tasks = [StressTest1]


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
