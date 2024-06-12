import 'package:flutter/material.dart';
import 'package:frontend/models.dart';
import 'package:frontend/services.dart';

class ReservationPage extends StatefulWidget {
  final String user;

  const ReservationPage({Key? key, required this.user}) : super(key: key);
  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  late Future<List<Reservation>> futureReservations;

  @override
  void initState() {
    super.initState();
    futureReservations = fetchReservationsByUser(user: widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservations'),
      ),
      body: FutureBuilder<List<Reservation>>(
        future: futureReservations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Reservation> reservations = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Movie Show UUID')),
                  DataColumn(label: Text('Selected Seats')),
                ],
                rows: reservations.map((reservation) {
                  final nameController =
                      TextEditingController(text: reservation.user);
                  final movieShowUuidController =
                      TextEditingController(text: reservation.movieShowUuid);
                  final seatController = TextEditingController(
                      text: '${reservation.seat.X}, ${reservation.seat.Y}');

                  return DataRow(cells: [
                    DataCell(TextField(
                        controller: nameController,
                        onSubmitted: (value) {
                          reservation.user = value;
                        })),
                    DataCell(TextField(
                        controller: movieShowUuidController,
                        onSubmitted: (value) {
                          reservation.movieShowUuid = value;
                        })),
                    DataCell(TextField(
                        controller: seatController,
                        onSubmitted: (value) {
                          final parts = value.split(',');
                          reservation.seat = Seat(
                              X: int.parse(parts[0]), Y: int.parse(parts[1]));
                        })),
                  ]);
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
