import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/components/seat_widget.dart';
import 'package:frontend/models.dart';
import 'package:frontend/pages/reservation_page.dart';
import 'package:frontend/services.dart';
import 'package:intl/intl.dart';

class SeatSelectionPage extends StatefulWidget {
  final MovieShow movieShow;

  const SeatSelectionPage({super.key, required this.movieShow});

  @override
  _SeatSelectionPageState createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage> {
  late Future<List<Reservation>> seatReservations;
  late Future<CinemaRoom> cinemaRoom;
  late Map<Seat, bool> selectedSeats;
  bool submitHover = false;
  bool inputHover = false;
  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    seatReservations = fetchReservations(movieShow: widget.movieShow);
    cinemaRoom = fetchCinemaRoom(cinemaRoomName: widget.movieShow.roomName);
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
          child: FutureBuilder(
            future: Future.wait([seatReservations, cinemaRoom]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<Reservation> reservations =
                    snapshot.data![0] as List<Reservation>;
                CinemaRoom room = snapshot.data![1] as CinemaRoom;
                for (Seat seat in room.seats) {
                  seat.isReserved = reservations
                      .any((reservation) => reservation.seat == seat);
                }
                return Column(
                  children: [
                    const SizedBox(height: 16),
                    Container(color: Colors.black, width: 1024, height: 16),
                    const SizedBox(height: 128),
                    SizedBox(
                      width:
                          (room.seats.map((seat) => seat.X).reduce(max) + 1) *
                              64.0,
                      height:
                          (room.seats.map((seat) => seat.Y).reduce(max) + 1) *
                              64.0,
                      child: Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: room.seats.map((seat) {
                            return Positioned(
                              left: seat.X * 64.0,
                              top: seat.Y * 64.0,
                              child: reservations.any(
                                      (reservation) => reservation.seat == seat)
                                  ? SeatWidget(
                                      seat: seat,
                                      onSelected: (isSelected) =>
                                          selectedSeats[seat] = isSelected,
                                      reservedBy: reservations
                                          .firstWhere((reservation) =>
                                              reservation.seat == seat)
                                          .user,
                                    )
                                  : SeatWidget(
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
                        ReserveSeatsButton(
                          onPressed: () async {
                            String name = nameController.text;
                            List<Seat> selectedSeatsList = selectedSeats.entries
                                .where((entry) => entry.value)
                                .map((entry) => entry.key)
                                .toList();
                            await createReservation(
                                user: name,
                                movieShowUuid: widget.movieShow.uuid,
                                selectedSeats: selectedSeatsList);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReservationsPage()),
                            );
                          },
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

class ReserveSeatsButton extends StatefulWidget {
  final Function onPressed;

  ReserveSeatsButton({required this.onPressed});

  @override
  _ReserveSeatsButtonState createState() => _ReserveSeatsButtonState();
}

class _ReserveSeatsButtonState extends State<ReserveSeatsButton> {
  bool submitHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onHover: (event) => setState(() => submitHover = true),
      onExit: (event) => setState(() => submitHover = false),
      child: OutlinedButton(
        onPressed: () async {
          widget.onPressed();
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
    );
  }
}
