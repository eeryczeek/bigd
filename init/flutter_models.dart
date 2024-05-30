// models/reservation.dart
class Reservation {
  String reservationId;
  String userId;
  String movieId;
  String seatNumber;
  DateTime reservationDate;
  String status;

  Reservation(
      {this.reservationId,
      this.userId,
      this.movieId,
      this.seatNumber,
      this.reservationDate,
      this.status});

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      reservationId: json['reservation_id'],
      userId: json['user_id'],
      movieId: json['movie_id'],
      seatNumber: json['seat_number'],
      reservationDate: DateTime.parse(json['reservation_date']),
      status: json['status'],
    );
  }
}
