from locust import HttpUser, task, between, SequentialTaskSet
import random


class CassandraStressUser(HttpUser):

    @task
    class StressTest1(SequentialTaskSet):
        def on_start(self):
            self.endpoint = "/your/cassandra/endpoint"
            self.data = {"key": "value"}

        @task(10000)
        def make_same_request_quickly(self):
            self.client.post(self.endpoint, json=self.data)

    @task
    class StressTest2(SequentialTaskSet):
        def on_start(self):
            self.endpoints = ["/endpoint1", "/endpoint2"]
            self.data = {"key": "value"}

        @task(10000)
        def make_random_requests(self):
            endpoint = random.choice(self.endpoints)
            self.client.post(endpoint, json=self.data)

    # ... similar for StressTest3, StressTest4, StressTest5
