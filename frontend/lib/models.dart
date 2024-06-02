class Movie {
  final uuid;
  final String title;
  final int duration;
  final List<String> genres;
  final double rating;

  Movie({
    required this.uuid,
    required this.title,
    required this.duration,
    required this.genres,
    required this.rating,
  });
}

class Seat {
  final uuid;
  final int X;
  final int Y;
  final bool isReserved;

  const Seat(
      {required this.uuid,
      required this.X,
      required this.Y,
      required this.isReserved});
}

class CinemaRoom {
  final uuid;
  final String name;
  final List<Seat> seats;

  CinemaRoom({
    required this.uuid,
    required this.name,
    required this.seats,
  });
}

class MovieShow {
  final uuid;
  final Movie movie;
  final cinemaRoomUuid;
  final DateTime showTime;

  MovieShow({
    required this.uuid,
    required this.movie,
    required this.cinemaRoomUuid,
    required this.showTime,
  });
}
