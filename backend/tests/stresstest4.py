import random
import requests
import uuid

BASE_URL = "http://localhost:8000"


def reservations_post_delete():
    with requests.Session() as s:
        movieShow = s.get(f"{BASE_URL}/shows/The Dark Knight").json()[0]
        cinemaRoom = s.get(f"{BASE_URL}/rooms/{movieShow['room_name']}").json()
        reservations = s.get(
            f"{BASE_URL}/reservations/show/{movieShow['show_id']}").json()

        available_seats = [
            seat for seat in cinemaRoom['seats'] if seat not in reservations]

        selected_seat = random.choice(available_seats)
        selected_seat = {"x": selected_seat['x'], "y": selected_seat['y']}

        for _ in range(1000):
            uuid_v4 = str(uuid.uuid4())
            s.post(f"{BASE_URL}/reservations/{movieShow['show_id']}",
                   json={"id": uuid_v4, "show_id": movieShow['show_id'], "seat": selected_seat, "user_mail": "user1"}, headers={'Content-Type': 'application/json; charset=UTF-8'})
            s.delete(
                f"{BASE_URL}/reservations/{uuid_v4}")


if __name__ == "__main__":
    reservations_post_delete()
