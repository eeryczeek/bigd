DROP KEYSPACE IF EXISTS cinema;

CREATE KEYSPACE IF NOT EXISTS cinema WITH replication = {
    'class': 'SimpleStrategy',
    'replication_factor': 3
};

USE cinema;

CREATE TYPE IF NOT EXISTS seat (
    x INT,
    y INT
);

-- Movies table
CREATE TABLE IF NOT EXISTS movies (
    title TEXT PRIMARY KEY,
    duration INT,
    genres LIST<TEXT>,
    rating FLOAT
);


-- Cinema Rooms table
CREATE TABLE IF NOT EXISTS cinema_rooms (
    name TEXT PRIMARY KEY,
    seats LIST<frozen<seat>>
);

-- Shows table
CREATE TABLE IF NOT EXISTS movie_shows_by_movie (
    show_id UUID,
    movie_title TEXT,
    room_name TEXT,
    show_time TIMESTAMP,
    PRIMARY KEY (movie_title, show_time, show_id)
) WITH CLUSTERING ORDER BY (show_time ASC);

CREATE TABLE IF NOT EXISTS movie_shows_by_id (
    show_id UUID PRIMARY KEY,
    movie_title TEXT,
    room_name TEXT,
    show_time TIMESTAMP
);

CREATE TABLE IF NOT EXISTS seats_by_show (
    show_id UUID,
    seat frozen<seat>,
    is_reserved BOOLEAN,
    PRIMARY KEY (show_id, seat)
);

-- Reservations table
CREATE TABLE IF NOT EXISTS reservations (
    id UUID,
    show_id UUID,
    seat frozen<seat>,
    user_mail TEXT,
    PRIMARY KEY (show_id, seat)
);

CREATE INDEX IF NOT EXISTS ON reservations (user_mail);
CREATE INDEX IF NOT EXISTS ON reservations (id);
