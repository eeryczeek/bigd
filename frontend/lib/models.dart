class Movie {
  final String title;
  final int duration;
  final List<String> genres;
  final double rating;

  Movie({
    required this.title,
    required this.duration,
    required this.genres,
    required this.rating,
  });
}

class Seat {
  final int X;
  final int Y;
  bool isReserved = false;

  Seat({required this.X, required this.Y, this.isReserved = false});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Seat && other.X == X && other.Y == Y;
  }
}

class CinemaRoom {
  final String name;
  final List<Seat> seats;

  CinemaRoom({
    required this.name,
    required this.seats,
  });
}

class Reservation {
  String user;
  String movieShowUuid;
  Seat seat;

  Reservation({
    required this.user,
    required this.movieShowUuid,
    required this.seat,
  });
}

class MovieShow {
  final String uuid;
  final String movieTitle;
  final String roomName;
  final DateTime showTime;

  MovieShow({
    required this.uuid,
    required this.movieTitle,
    required this.roomName,
    required this.showTime,
  });
}
