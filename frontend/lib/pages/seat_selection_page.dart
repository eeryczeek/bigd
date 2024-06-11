import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/components/seat_widget.dart';
import 'package:frontend/models.dart';
import 'package:frontend/services.dart';

class SeatSelectionPage extends StatefulWidget {
  final MovieShow movieShow;

  const SeatSelectionPage({required this.movieShow});

  @override
  _SeatSelectionPageState createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage> {
  late Future<List<Seat>> seatReservations;
  late Map<Seat, bool> selectedSeats;

  @override
  void initState() {
    super.initState();
    seatReservations = fetchReservations(movieShow: widget.movieShow);
    selectedSeats = {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: Text(
              '${widget.movieShow.movie.title} - ${widget.movieShow.showTime.day}.${widget.movieShow.showTime.month}.${widget.movieShow.showTime.year} - ${widget.movieShow.showTime.hour}:${widget.movieShow.showTime.minute}'),
        ),
        body: Center(
          child: FutureBuilder<List<Seat>>(
            future: seatReservations,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Column(
                  children: [
                    const SizedBox(height: 16),
                    Container(color: Colors.black, width: 1024, height: 16),
                    const SizedBox(height: 64),
                    SizedBox(
                      width: (snapshot.data!.map((seat) => seat.X).reduce(max) +
                              1) *
                          64.0,
                      height:
                          (snapshot.data!.map((seat) => seat.Y).reduce(max) +
                                  1) *
                              64.0,
                      child: Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: snapshot.data!.map((seat) {
                            return Positioned(
                              left: seat.X * 64.0,
                              top: seat.Y * 64.0,
                              child: SeatWidget(
                                seat: seat,
                                onSelected: (isSelected) =>
                                    selectedSeats[seat] = isSelected,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (selectedSeats.isNotEmpty) {
                          createReservation(
                            movieShow: widget.movieShow,
                            selectedSeats: selectedSeats,
                          );
                        }
                      },
                      child: const Text('Proceed to checkout'),
                    ),
                  ],
                );
              }
            },
          ),
        ));
  }
}
