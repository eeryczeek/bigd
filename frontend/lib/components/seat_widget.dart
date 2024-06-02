import 'package:flutter/material.dart';
import 'package:frontend/models.dart';

class SeatWidget extends StatelessWidget {
  final Seat seat;
  final bool isSelected;
  final VoidCallback onTap;

  const SeatWidget({
    required this.seat,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: seat.isReserved
              ? Colors.black
              : isSelected
                  ? Colors.blue
                  : Colors.grey,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
