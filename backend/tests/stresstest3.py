import requests
import threading

BASE_URL = "http://localhost:8000"


def create_reservation1():
    with requests.Session() as s:
        movieShow = s.get(f"{BASE_URL}/shows/Inception").json()[0]
        cinemaRoom = s.get(f"{BASE_URL}/rooms/{movieShow['room_name']}").json()
        reservations = s.get(
            f"{BASE_URL}/reservations/show/{movieShow['show_id']}").json()
        available_seats = [
            seat for seat in cinemaRoom['seats'] if seat not in reservations]
        for seat in available_seats:
            s.post(f"{BASE_URL}/reservations/{movieShow['show_id']}",
                   json={"show_id": movieShow['show_id'], "seat": seat, "user_mail": "user1"}, headers={'Content-Type': 'application/json; charset=UTF-8'})


def create_reservation2():
    with requests.Session() as s:
        movieShow = s.get(f"{BASE_URL}/shows/Inception").json()[0]
        cinemaRoom = s.get(f"{BASE_URL}/rooms/{movieShow['room_name']}").json()
        reservations = s.get(
            f"{BASE_URL}/reservations/show/{movieShow['show_id']}").json()
        available_seats = [
            seat for seat in cinemaRoom['seats'] if seat not in reservations]
        for seat in available_seats:
            s.post(f"{BASE_URL}/reservations/{movieShow['show_id']}",
                   json={"show_id": movieShow['show_id'], "seat": seat, "user_mail": "user2"}, headers={'Content-Type': 'application/json; charset=UTF-8'})


if __name__ == "__main__":
    thread1 = threading.Thread(target=create_reservation1)
    thread2 = threading.Thread(target=create_reservation2)

    thread1.start()
    thread2.start()

    thread1.join()
    thread2.join()
