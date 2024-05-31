import 'package:flutter/material.dart';
import 'package:frontend/models/seat.dart';

class SeatsPage extends StatefulWidget {
  final String movieTitle;
  final String showTime;

  const SeatsPage({required this.movieTitle, required this.showTime});

  @override
  _SeatsPageState createState() => _SeatsPageState();
}

class _SeatsPageState extends State<SeatsPage> {
  List<bool> selectedSeats = List.generate(21, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.movieTitle} - ${widget.showTime}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.8,
                child: GridView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: 21,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    return Seat(
                      isSelected: selectedSeats[index],
                      onTap: () {
                        setState(() {
                          selectedSeats[index] = !selectedSeats[index];
                        });
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Send the info about reserved seats to your database
            },
            child: const Text('Reserve'),
          ),
        ],
      ),
    );
  }
}

class CinemaRoom {
  final int rows;
  final int columns;

  CinemaRoom({required this.rows, required this.columns});

  int get totalSeats => rows * columns;
}
