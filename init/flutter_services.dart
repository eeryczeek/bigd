// services/api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/reservation.dart';

class ApiService {
  final String baseUrl = "http://your-django-api-url";

  Future<Reservation> createReservation(Reservation reservation) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reservations/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reservation.toJson()),
    );
    if (response.statusCode == 201) {
      return Reservation.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create reservation');
    }
  }

  Future<Reservation> getReservation(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/reservations/$id/'));
    if (response.statusCode == 200) {
      return Reservation.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load reservation');
    }
  }

  Future<void> updateReservation(Reservation reservation) async {
    final response = await http.put(
      Uri.parse('$baseUrl/reservations/${reservation.reservationId}/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reservation.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update reservation');
    }
  }

  Future<void> deleteReservation(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/reservations/$id/'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete reservation');
    }
  }
}
