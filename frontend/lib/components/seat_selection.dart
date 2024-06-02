import 'package:flutter/material.dart';
import 'package:frontend/models.dart';
import 'package:frontend/components/seat_widget.dart';

class SeatSelection extends StatefulWidget {
  final MovieShow movieShow;
  final List<Seat> seats;

  const SeatSelection({
    Key? key,
    required this.movieShow,
    required this.seats,
  }) : super(key: key);

  @override
  _SeatSelection createState() => _SeatSelection();
}

class _SeatSelection extends State<SeatSelection> {
  List<bool> selectedSeats = [];

  @override
  void initState() {
    super.initState();
    selectedSeats = List.generate(widget.seats.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: widget.seats.map((seat) {
        int index = widget.seats.indexOf(seat);
        return Positioned(
          left: seat.X * 64.0,
          top: seat.Y * 64.0,
          child: SeatWidget(
            seat: seat,
            isSelected: selectedSeats[index],
            onTap: () {
              setState(() {
                selectedSeats[index] = !selectedSeats[index];
              });
            },
          ),
        );
      }).toList(),
    );
  }
}
