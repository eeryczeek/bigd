import 'package:flutter/material.dart';
import 'package:frontend/components/seat_selection.dart';
import 'package:frontend/models.dart';

class SeatSelectionPage extends StatefulWidget {
  final MovieShow movieShow;

  const SeatSelectionPage({required this.movieShow});

  @override
  _SeatSelectionPageState createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage> {
  List<bool> selectedSeats = List.generate(21, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.movieShow.movie.title} - ${widget.movieShow.showTime}'),
      ),
      body: SeatSelection(
        movieShow: widget.movieShow,
        seats: List.generate(
          21,
          (index) => Seat(
            uuid: 'uuid',
            X: index % 7,
            Y: index ~/ 7,
            isReserved: false,
          ),
        ),
      ),
    );
  }
}
