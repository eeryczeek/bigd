class Movie {
  final String uuid;
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
  final String uuid;
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
  final String uuid;
  final String name;
  final List<Seat> seats;

  CinemaRoom({
    required this.uuid,
    required this.name,
    required this.seats,
  });
}

class MovieShow {
  final String uuid;
  final Movie movie;
  final String cinemaRoomUuid;
  final DateTime showTime;

  MovieShow({
    required this.uuid,
    required this.movie,
    required this.cinemaRoomUuid,
    required this.showTime,
  });
}
