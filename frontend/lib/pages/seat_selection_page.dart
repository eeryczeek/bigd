import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/components/seat_widget.dart';
import 'package:frontend/models.dart';
import 'package:frontend/services.dart';
import 'package:intl/intl.dart';

class SeatSelectionPage extends StatefulWidget {
  final MovieShow movieShow;

  const SeatSelectionPage({required this.movieShow});

  @override
  _SeatSelectionPageState createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage> {
  late Future<List<Seat>> seatReservations;
  late Map<Seat, bool> selectedSeats;
  bool submitHover = false;
  bool inputHover = false;
  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    seatReservations = fetchReservations(movieShow: widget.movieShow);
    selectedSeats = {};
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Theme.of(context).colorScheme.primary,
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: Text(
              '${widget.movieShow.movieTitle}: ${DateFormat('yyyy-MM-dd hh:mm').format(widget.movieShow.showTime)}',
              style: Theme.of(context).textTheme.titleLarge),
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
                    const SizedBox(height: 128),
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
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 256,
                          height: 32,
                          child: TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(16.0)),
                                borderSide: BorderSide(
                                  color: inputHover
                                      ? Theme.of(context).colorScheme.tertiary
                                      : Theme.of(context).colorScheme.secondary,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(16.0)),
                                borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(16.0)),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  width: 2,
                                ),
                              ),
                              hintText: 'Enter your name',
                              hintStyle: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w300,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onHover: (event) =>
                              setState(() => submitHover = true),
                          onExit: (event) =>
                              setState(() => submitHover = false),
                          child: OutlinedButton(
                            onPressed: () {
                              String name = nameController.text;
                              List<Seat> selectedSeatsList = selectedSeats
                                  .entries
                                  .where((entry) => entry.value)
                                  .map((entry) => entry.key)
                                  .toList();
                              createReservation(
                                  user: name,
                                  movieShowUuid: widget.movieShow.uuid,
                                  selectedSeats: selectedSeatsList);
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: submitHover
                                    ? Theme.of(context).colorScheme.tertiary
                                    : Theme.of(context).colorScheme.secondary,
                                width: 2,
                              ),
                            ),
                            child: const Text(
                              'Reserve seats',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
            },
          ),
        ));
  }
}
