import 'package:frontend/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Movie>> fetchMovies() async {
  final response = await http.get(Uri.parse('http://localhost:8000/movies'));

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
}

Future<List<MovieShow>> fetchMovieShows({required String movieTitle}) async {
  final response =
      await http.get(Uri.parse('http://localhost:8000/shows/$movieTitle'));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data
        .map((movieShow) => MovieShow(
              uuid: movieShow['show_id'],
              movieTitle: movieShow['movie_title'],
              roomName: movieShow['room_name'],
              showTime: DateTime.parse(movieShow['show_time']),
            ))
        .toList();
  } else {
    return <MovieShow>[];
  }
}

Future<CinemaRoom> fetchCinemaRoom({required String cinemaRoomName}) async {
  final response =
      await http.get(Uri.parse('http://localhost:8000/rooms/$cinemaRoomName'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return CinemaRoom(
      name: data['name'],
      seats: List<Seat>.from(data['seats'].map((seat) =>
          Seat(X: seat['x'], Y: seat['y'], isReserved: seat['is_reserved']))),
    );
  } else {
    throw Exception('Failed to load cinema room');
  }
}

Future<List<Reservation>> fetchReservations(
    {required MovieShow movieShow}) async {
  final response = await http
      .get(Uri.parse('http://localhost:8000/reservations/${movieShow.uuid}'));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return <Reservation>[
      for (var reservation in data)
        Reservation(
            user: reservation['user_mail'],
            movieShowUuid: reservation['show_id'],
            seat: Seat(
                X: reservation['seat']['x'],
                Y: reservation['seat']['y'],
                isReserved: reservation['seat']['is_reserved']))
    ];
  } else {
    throw Exception('Failed to load reservations');
  }
}

Future<List<Reservation>> fetchReservationsByUser(
    {required String user}) async {
  final response = await http
      .get(Uri.parse('http://localhost:8000/reservations/user/$user'));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return <Reservation>[
      for (var reservation in data)
        Reservation(
            user: reservation['user_mail'],
            movieShowUuid: reservation['show_id'],
            seat: Seat(
                X: reservation['seat']['x'],
                Y: reservation['seat']['y'],
                isReserved: reservation['seat']['is_reserved']))
    ];
  } else {
    throw Exception('Failed to load reservations');
  }
}

Future<void> createReservation(
    {required String user,
    required String movieShowUuid,
    required List<Seat> selectedSeats}) async {
  for (var seat in selectedSeats) {
    final response = await http.post(
      Uri.parse('http://localhost:8000/reservations/$movieShowUuid'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'show_id': movieShowUuid,
        'seat': {'x': seat.X, 'y': seat.Y, 'is_reserved': true},
        'user_mail': user
      }),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to create reservation');
    }
  }
}
