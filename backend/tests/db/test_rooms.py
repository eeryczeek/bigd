from db.rooms import get_room_by_name, create_room, delete_room_by_name
from models import CinemaRoom, Seat
import unittest


class TestRooms(unittest.TestCase):
    def all_functions(self):
        create_room(CinemaRoom(name="Test Room", seats=[Seat(x=1, y=1)]))
        room = get_room_by_name("Test Room")
        self.assertEqual(room.name, "Test Room")
        self.assertEqual(room.seats[0].x, 1)
        self.assertEqual(room.seats[0].y, 1)

        delete_room_by_name("Test Room")
        room = get_room_by_name("Test Room")
        self.assertIsNone(room)
