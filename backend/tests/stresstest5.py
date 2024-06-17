from locust import HttpUser, task, between, SequentialTaskSet, TaskSet, events
from locust.env import Environment
from locust.stats import stats_printer, stats_history
from locust.log import setup_logging
import gevent


class StressTest5(SequentialTaskSet):
    @ task
    def update_reservations(self):
        response = self.client.get('/shows/Inception')
        if response.status_code == 200:
            movieShow = response.json()[0]
            for _ in range(1000):
                reservation_data = {
                    "show_id": movieShow['show_id'],
                    "seat": {"x": 1, "y": 1, "is_reserved": True},
                    "user_mail": "user"
                }
                self.client.post(
                    f"/reservations/{movieShow['show_id']}", json=reservation_data)
                self.client.put(
                    f"/reservations/{movieShow['show_id']}", json=reservation_data)


class UserBehavior(HttpUser):
    host = "http://localhost:8000"
    wait_time = between(0, 0)
    tasks = [StressTest5]


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
