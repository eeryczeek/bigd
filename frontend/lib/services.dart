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
    return <Movie>[
      Movie(
        title: 'Movie Title',
        duration: 120,
        genres: ['Action', 'Adventure'],
        rating: 8.0,
      ),
      Movie(
        title: 'Movie Title',
        duration: 120,
        genres: ['Action', 'Adventure'],
        rating: 8.0,
      ),
      Movie(
        title: 'Movie Title',
        duration: 120,
        genres: ['Action', 'Adventure'],
        rating: 8.0,
      ),
      Movie(
        title: 'Movie Title',
        duration: 120,
        genres: ['Action', 'Adventure'],
        rating: 8.0,
      ),
      Movie(
        title: 'Movie Title',
        duration: 120,
        genres: ['Action', 'Adventure'],
        rating: 8.0,
      ),
      Movie(
        title: 'Movie Title',
        duration: 120,
        genres: ['Action', 'Adventure'],
        rating: 8.0,
      ),
      Movie(
        title: 'Movie Title',
        duration: 120,
        genres: ['Action', 'Adventure'],
        rating: 8.0,
      ),
      Movie(
        title: 'Movie Title',
        duration: 120,
        genres: ['Action', 'Adventure'],
        rating: 8.0,
      ),
    ];
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
    return <MovieShow>[
      MovieShow(
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
      ),
      MovieShow(
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
        showTime: DateTime.now().add(const Duration(hours: 2)),
      ),
    ];
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
      seats: <Seat>[
        Seat(X: 0, Y: 0),
        Seat(X: 0, Y: 1),
        Seat(X: 0, Y: 2),
        Seat(X: 0, Y: 3),
        Seat(X: 1, Y: 0),
        Seat(X: 1, Y: 1),
        Seat(X: 1, Y: 2),
        Seat(X: 1, Y: 3),
        Seat(X: 2, Y: 0),
        Seat(X: 2, Y: 1),
        Seat(X: 2, Y: 2),
        Seat(X: 2, Y: 3),
      ],
    );
  }
}

Future<Map<Seat, bool>> fetchReservations(
    {required MovieShow movieShow}) async {
  try {
    final response = await http.get(Uri.parse(
        'https://reservations/${movieShow.cinemaRoom.name}/${movieShow.showTime}/seats'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return {
        for (var seat in data)
          Seat(X: seat['X'], Y: seat['Y']): seat['isSelected']
      };
    } else {
      throw Exception('Failed to load reservations');
    }
  } catch (e) {
    print('Failed to fetch seats: $e');
    return <Seat, bool>{
      Seat(X: 0, Y: 0): false,
      Seat(X: 0, Y: 1): false,
      Seat(X: 0, Y: 2): false,
      Seat(X: 0, Y: 3): false,
      Seat(X: 1, Y: 0): false,
      Seat(X: 1, Y: 1): false,
      Seat(X: 1, Y: 2): false,
      Seat(X: 1, Y: 3): false,
      Seat(X: 2, Y: 0): false,
      Seat(X: 2, Y: 1): false,
      Seat(X: 2, Y: 2): false,
      Seat(X: 2, Y: 3): false,
    };
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
