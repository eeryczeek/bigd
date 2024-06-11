import 'dart:math';

import 'package:frontend/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Movie>> fetchMovies() async {
  try {
    final response = await http.get(Uri.parse('https://movies'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((movie) => Movie(
                title: movie['title'],
                duration: movie['duration'],
                genres: List<String>.from(movie['genres']),
                rating: movie['rating'],
              ))
          .toList();
    } else {
      return <Movie>[];
    }
  } catch (e) {
    print('Failed to fetch movies: $e');
    return List<Movie>.generate(
      8,
      (index) => Movie(
        title: 'Movie Title',
        duration: 120,
        genres: ['Action', 'Adventure'],
        rating: 8.0,
      ),
    );
  }
}

Future<List<MovieShow>> fetchMovieShows({required String movieTitle}) async {
  try {
    final response =
        await http.get(Uri.parse('https://movies/$movieTitle/movie_shows'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((movieShow) => MovieShow(
                movie: movieShow['movie'],
                cinemaRoom: movieShow['cinema_room'],
                showTime: DateTime.parse(movieShow['show_time']),
              ))
          .toList();
    } else {
      return <MovieShow>[];
    }
  } catch (e) {
    print('Failed to fetch movie shows: $e');
    return List<MovieShow>.generate(
        3,
        (index) => MovieShow(
              movie: Movie(
                title: 'Movie Title',
                duration: 120,
                genres: ['Action', 'Adventure'],
                rating: 8.0,
              ),
              cinemaRoom: CinemaRoom(
                name: 'Cinema Room Name',
                seats: <Seat>[],
              ),
              showTime: DateTime.now(),
            ));
  }
}

Future<CinemaRoom> fetchCinemaRoom({required String cinemaRoomName}) async {
  try {
    final response =
        await http.get(Uri.parse('https://cinema_rooms/$cinemaRoomName'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return CinemaRoom(
        name: data['name'],
        seats: List<Seat>.from(
            data['seats'].map((seat) => Seat(X: seat['X'], Y: seat['Y']))),
      );
    } else {
      throw Exception('Failed to load cinema room');
    }
  } catch (e) {
    print('Failed to fetch cinema room: $e');
    return CinemaRoom(
      name: 'Cinema Room Name',
      seats: List<Seat>.generate(
        32,
        (index) => Seat(X: index % 8, Y: index ~/ 8),
      ),
    );
  }
}

Future<List<Seat>> fetchReservations({required MovieShow movieShow}) async {
  try {
    final response = await http.get(Uri.parse(
        'https://reservations/${movieShow.cinemaRoom.name}/${movieShow.showTime}/seats'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return <Seat>[
        for (var seat in data)
          Seat(X: seat['X'], Y: seat['Y'], isReserved: true)
      ];
    } else {
      throw Exception('Failed to load reservations');
    }
  } catch (e) {
    print('Failed to fetch seats: $e');
    return List<Seat>.generate(
      32,
      (index) =>
          Seat(X: index % 8, Y: index ~/ 8, isReserved: Random().nextBool()),
    );
  }
}

Future<void> createReservation(
    {required MovieShow movieShow,
    required Map<Seat, bool> selectedSeats}) async {
  try {
    final response = await http.post(
      Uri.parse(
          'https://reservations/${movieShow.cinemaRoom.name}/${movieShow.showTime}/seats'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'seats': [
          for (var seat in selectedSeats.entries.where((seat) => seat.value))
            {'X': seat.key.X, 'Y': seat.key.Y}
        ],
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create reservation');
    }
  } catch (e) {
    print('Failed to create reservation: $e');
  }
}
