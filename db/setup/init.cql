-- Keyspace creation
CREATE KEYSPACE cinema
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 3};

-- Users table
CREATE TABLE cinema.users (
    user_id UUID PRIMARY KEY,
    name TEXT,
    email TEXT
);
CREATE INDEX ON cinema.users(email);

-- Movies table
CREATE TABLE cinema.movies (
    movie_id UUID,
    title TEXT,
    duration INT,
    genres LIST<TEXT>,
    rating FLOAT,
    PRIMARY KEY (movie_id, title)
) WITH CLUSTERING ORDER BY (title ASC);
CREATE INDEX ON cinema.movies(title);

-- Cinema Rooms table
CREATE TABLE cinema.cinema_rooms (
    room_id UUID PRIMARY KEY,
    name TEXT
);

-- Seats table
CREATE TABLE cinema.seats (
    seat_id UUID,
    room_id UUID,
    x INT,
    y INT,
    PRIMARY KEY (room_id, seat_id)
);

-- Shows table
CREATE TABLE cinema.movie_shows (
    show_id UUID,
    movie_id UUID,
    cinema_room_id UUID,
    show_time TIMESTAMP,
    PRIMARY KEY (show_id, show_time)
) WITH CLUSTERING ORDER BY (show_time ASC);
CREATE INDEX ON cinema.movie_shows(movie_id);

CREATE TABLE cinema.seats_by_show (
    show_id UUID,
    seat_id UUID,
    room_id UUID,
    x INT,
    y INT,
    available BOOLEAN,
    PRIMARY KEY (show_id, seat_id)
);

-- Reservations table
CREATE TABLE cinema.seat_reservations (
    cinema_room_id UUID,
    show_id UUID,
    seat_id UUID,
    user_id UUID,
    PRIMARY KEY ((show_id, seat_id))
);
CREATE INDEX ON cinema.seat_reservations(user_id);
