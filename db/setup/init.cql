-- Keyspace creation
CREATE KEYSPACE cinema
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 3};

-- Movies table
CREATE TABLE cinema.movies (
    title TEXT,
    duration INT,
    genres LIST<TEXT>,
    rating FLOAT,
    PRIMARY KEY (title, rating)
) WITH CLUSTERING ORDER BY (rating DESC);

CREATE TYPE seat (
    x INT,
    y INT,
    is_reserved BOOLEAN
);

-- Cinema Rooms table
CREATE TABLE cinema.cinema_rooms (
    name TEXT PRIMARY KEY,
    seats LIST<seat>
);

-- Shows table
CREATE TABLE cinema.movie_shows_by_movie (
    show_id UUID,
    movie_title TEXT,
    room_name TEXT,
    show_time TIMESTAMP,
    PRIMARY KEY (movie_title, show_time, room_name)
) WITH CLUSTERING ORDER BY (show_time ASC);

CREATE TABLE cinema.movie_shows_by_id (
    show_id UUID PRIMARY KEY,
    movie_title TEXT,
    room_name TEXT,
    show_time TIMESTAMP
);

CREATE TABLE cinema.seats_by_show (
    show_id UUID,
    seat seat,
    PRIMARY KEY (show_id, seat)
);

-- Reservations table
CREATE TABLE cinema.seat_reservations (
    show_id UUID,
    seat seat,
    user_mail TEXT,
    PRIMARY KEY ((show_id, seat), mail)
);

CREATE TABLE cinema.reservations_by_user (
    user_mail TEXT,
    show_id UUID,
    seat seat,
    PRIMARY KEY (user_mail, show_id)
);
