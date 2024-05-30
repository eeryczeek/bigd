// main.dart
import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'models/reservation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ReservationScreen(),
    );
  }
}

class ReservationScreen extends StatefulWidget {
  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final ApiService apiService = ApiService();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _movieIdController = TextEditingController();
  final TextEditingController _seatNumberController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String _status = 'Booked';

  void _createReservation() async {
    Reservation reservation = Reservation(
      userId: _userIdController.text,
      movieId: _movieIdController.text,
      seatNumber: _seatNumberController.text,
      reservationDate: DateTime.parse(_dateController.text),
      status: _status,
    );
    try {
      await apiService.createReservation(reservation);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Reservation created')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create reservation')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cinema Reservations')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _userIdController,
              decoration: InputDecoration(labelText: 'User ID'),
            ),
            TextField(
              controller: _movieIdController,
              decoration: InputDecoration(labelText: 'Movie ID'),
            ),
            TextField(
              controller: _seatNumberController,
              decoration: InputDecoration(labelText: 'Seat Number'),
            ),
            TextField(
              controller: _dateController,
              decoration:
                  InputDecoration(labelText: 'Reservation Date (YYYY-MM-DD)'),
            ),
            DropdownButton<String>(
              value: _status,
              onChanged: (String newValue) {
                setState(() {
                  _status = newValue;
                });
              },
              items: <String>['Booked', 'Cancelled']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: _createReservation,
              child: Text('Create Reservation'),
            ),
          ],
        ),
      ),
    );
  }
}
