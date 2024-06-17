import 'package:flutter/material.dart';
import 'package:frontend/models.dart';
import 'package:frontend/services.dart';

class ReservationsPage extends StatefulWidget {
  @override
  _ReservationsPageState createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  late Future<List<Reservation>> reservations;

  @override
  void initState() {
    super.initState();
    reservations = fetchAllReservations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservations'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Reservation>>(
              future: reservations,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return DataTable(
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text('Show ID'),
                      ),
                      DataColumn(
                        label: Text('Seat'),
                      ),
                      DataColumn(
                        label: Text('User Mail'),
                      ),
                      DataColumn(
                        label: Text('Actions'),
                      ),
                    ],
                    rows:
                        snapshot.data!.map<DataRow>((Reservation reservation) {
                      final userController =
                          TextEditingController(text: reservation.user);
                      return DataRow(
                        cells: <DataCell>[
                          DataCell(Text(reservation.movieShowUuid.toString())),
                          DataCell(Text(reservation.seat.toString())),
                          DataCell(TextField(
                            controller: userController,
                          )),
                          DataCell(Row(
                            children: <Widget>[
                              IconButton(
                                icon: const Icon(Icons.edit),
                                color: Colors.black,
                                onPressed: () {
                                  reservation.user = userController.text;
                                  editReservation(reservation: reservation);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.black,
                                onPressed: () async {
                                  try {
                                    await deleteReservation(
                                        uuid: reservation.uuid);
                                    setState(() {
                                      reservations = fetchAllReservations();
                                    });
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Failed to delete reservation: $e'),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          )),
                        ],
                      );
                    }).toList(),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }
}
