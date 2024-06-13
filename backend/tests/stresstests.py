from locust import HttpUser, task, between, SequentialTaskSet
import random

"""
 Stress Test 1: The client makes the same request very quickly min (10000 times).
 Stress Test 2: Two or more clients make the possible requests randomly (10000 times).
 Stress Test 3: Immediate occupancy of all seats/reservations by 2 clients.
    The idea is that we have one pool for reservation and 2 clients want to claim as much as possible.
    A situation where one client claims all is undesirable. 
 Stress Test 4: constant cancellations and seat occupancy. (For the same seat 10000 times)
 Stress Test 5: Update of 1000 reservations. (For example, change the date for all reservations)


"""


class CassandraStressUser(HttpUser):
    wait_time = between(0, 0)

    @task
    class StressTest1(SequentialTaskSet):
        def on_start(self):
            self.endpoint = "http://localhost:8000/movies"
            self.data = {}

        @task(10000)
        def make_same_request_quickly(self):
            self.client.get(self.endpoint, json=self.data)

    @task
    class StressTest2(SequentialTaskSet):
        def on_start(self):
            self.endpoints = ["/endpoint1", "/endpoint2"]
            self.data = {"key": "value"}

        @task(10000)
        def make_random_requests(self):
            endpoint = random.choice(self.endpoints)
            self.client.post(endpoint, json=self.data)

        @task
        class StressTest3(SequentialTaskSet):
            def on_start(self):
                self.endpoint = "/your/cassandra/reservation_endpoint"
                self.data = {"key": "value"}

            @task(2)
            def occupy_all_seats(self):
                self.client.post(self.endpoint, json=self.data)

        @task
        class StressTest4(SequentialTaskSet):
            def on_start(self):
                self.endpoint = "/your/cassandra/cancellation_endpoint"
                self.data = {"key": "value"}

            @task(10000)
            def constant_cancellations_and_occupancy(self):
                self.client.post(self.endpoint, json=self.data)

        @task
        class StressTest5(SequentialTaskSet):
            def on_start(self):
                self.endpoint = "/your/cassandra/update_endpoint"
                self.data = {"key": "value"}

            @task(1000)
            def update_reservations(self):
                self.client.put(self.endpoint, json=self.data)
