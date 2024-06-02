-- Create the keyspace
CREATE KEYSPACE IF NOT EXISTS cinema_keyspace WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 2};

-- Use the keyspace
USE cinema_keyspace;

-- Create movies table
CREATE TABLE IF NOT EXISTS movies (
    uuid UUID PRIMARY KEY,
    title TEXT,
    duration INT,
    genres LIST<TEXT>,
    rating DOUBLE
);

-- Create a custom type for seats
CREATE TYPE IF NOT EXISTS seat (
    uuid UUID,
    x INT,
    y INT
);

-- Create cinema rooms table
CREATE TABLE IF NOT EXISTS cinema_rooms (
    uuid UUID PRIMARY KEY,
    name TEXT,
    seats LIST<FROZEN<seat>>
);

-- Create movie shows table
CREATE TABLE IF NOT EXISTS movie_shows (
    uuid UUID PRIMARY KEY,
    movie_uuid UUID,
    cinema_room_uuid UUID,
    show_time TIMESTAMP
);

-- Create seat reservations table
CREATE TABLE IF NOT EXISTS seat_reservations (
    cinema_room_uuid UUID,
    show_time TIMESTAMP,
    seat_uuid UUID,
    user_id UUID,
    PRIMARY KEY ((cinema_room_uuid, show_time), seat_uuid)
);

-- Insert test data into movies table
INSERT INTO movies (uuid, title, duration, genres, rating) VALUES (uuid(), 'Inception', 148, ['Action', 'Sci-Fi'], 8.8);
INSERT INTO movies (uuid, title, duration, genres, rating) VALUES (uuid(), 'The Matrix', 136, ['Action', 'Sci-Fi'], 8.7);
INSERT INTO movies (uuid, title, duration, genres, rating) VALUES (uuid(), 'Interstellar', 169, ['Adventure', 'Drama', 'Sci-Fi'], 8.6);

-- Insert test data into cinema rooms table
INSERT INTO cinema_rooms (uuid, name, seats) VALUES (
    uuid(), 
    'Room 1', 
    [
        {uuid: uuid(), x: 1, y: 1}, 
        {uuid: uuid(), x: 1, y: 2}, 
        {uuid: uuid(), x: 1, y: 3}, 
        {uuid: uuid(), x: 2, y: 1}, 
        {uuid: uuid(), x: 2, y: 2}
    ]
);

INSERT INTO cinema_rooms (uuid, name, seats) VALUES (
    uuid(), 
    'Room 2', 
    [
        {uuid: uuid(), x: 1, y: 1}, 
        {uuid: uuid(), x: 1, y: 2}, 
        {uuid: uuid(), x: 1, y: 3}, 
        {uuid: uuid(), x: 2, y: 1}, 
        {uuid: uuid(), x: 2, y: 2}
    ]
);

-- Insert test data into movie shows table
INSERT INTO movie_shows (uuid, movie_uuid, cinema_room_uuid, show_time) VALUES (uuid(), (SELECT uuid FROM movies WHERE title = 'Inception' LIMIT 1), (SELECT uuid FROM cinema_rooms WHERE name = 'Room 1' LIMIT 1), '2024-06-01T18:30:00Z');
INSERT INTO movie_shows (uuid, movie_uuid, cinema_room_uuid, show_time) VALUES (uuid(), (SELECT uuid FROM movies WHERE title = 'The Matrix' LIMIT 1), (SELECT uuid FROM cinema_rooms WHERE name = 'Room 2' LIMIT 1), '2024-06-01T20:30:00Z');

-- Insert test data into seat reservations table
INSERT INTO seat_reservations (cinema_room_uuid, show_time, seat_uuid, user_id) VALUES (
    (SELECT uuid FROM cinema_rooms WHERE name = 'Room 1' LIMIT 1), 
    '2024-06-01T18:30:00Z', 
    (SELECT seat[0].uuid FROM cinema_rooms WHERE name = 'Room 1' LIMIT 1), 
    uuid()
);

INSERT INTO seat_reservations (cinema_room_uuid, show_time, seat_uuid, user_id) VALUES (
    (SELECT uuid FROM cinema_rooms WHERE name = 'Room 2' LIMIT 1), 
    '2024-06-01T20:30:00Z', 
    (SELECT seat[1].uuid FROM cinema_rooms WHERE name = 'Room 2' LIMIT 1), 
    uuid()
);
