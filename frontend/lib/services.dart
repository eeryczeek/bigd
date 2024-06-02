import 'package:frontend/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Movie>> fetchMovies() async {
  final response = await http.get(Uri.parse('https://movies'));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data
        .map((movie) => Movie(
              uuid: movie['uuid'],
              title: movie['title'],
              duration: movie['duration'],
              genres: List<String>.from(movie['genres']),
              rating: movie['rating'],
            ))
        .toList();
  } else {
    throw Exception('Failed to load movies');
  }
}

Future<List<MovieShow>> fetchMovieShows() async {
  final response =
      await http.get(Uri.parse('https://cinema_rooms/1/movie_shows'));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data
        .map((movieShow) => MovieShow(
              uuid: movieShow['uuid'],
              movie: Movie(
                uuid: movieShow['movie']['uuid'],
                title: movieShow['movie']['title'],
                duration: movieShow['movie']['duration'],
                genres: List<String>.from(movieShow['movie']['genres']),
                rating: movieShow['movie']['rating'],
              ),
              cinemaRoomUuid: movieShow['cinema_room_uuid'],
              showTime: DateTime.parse(movieShow['show_time']),
            ))
        .toList();
  } else {
    throw Exception('Failed to load movie shows');
  }
}

Future<CinemaRoom> fetchCinemaRoom(uuid) async {
  final response = await http.get(Uri.parse('https://cinema_rooms/$uuid'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return CinemaRoom(
      uuid: data['uuid'],
      name: data['name'],
      seats: List<Seat>.from(data['seats'].map((seat) => Seat(
            uuid: seat['uuid'],
            X: seat['X'],
            Y: seat['Y'],
            isReserved: seat['isReserved'],
          ))),
    );
  } else {
    throw Exception('Failed to load cinema room');
  }
}

Future<List<Seat>> fetchSeats(MovieShow movieShow) async {
  final response = await http.get(Uri.parse(
      'https://cinema_rooms/${movieShow.cinemaRoomUuid}/${movieShow.showTime}/seats'));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data
        .map((seat) => Seat(
              uuid: seat['uuid'],
              X: seat['X'],
              Y: seat['Y'],
              isReserved: seat['isReserved'],
            ))
        .toList();
  } else {
    throw Exception('Failed to load seats');
  }
}
