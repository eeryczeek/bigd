CREATE KEYSPACE cinema WITH REPLICATION = {
  'class': 'SimpleStrategy',
  'replication_factor': 3
};

USE cinema;

CREATE TABLE reservations (
  reservation_id UUID PRIMARY KEY,
  user_id UUID,
  movie_id UUID,
  seat_number text,
  reservation_date timestamp,
  status text
);

CREATE TABLE users (
  user_id UUID PRIMARY KEY,
  name text,
  email text
);

CREATE TABLE movies (
  movie_id UUID PRIMARY KEY,
  movie_name text,
  show_times list<timestamp>
);
