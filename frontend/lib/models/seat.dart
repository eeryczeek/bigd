import 'package:flutter/material.dart';

class Seat extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const Seat({required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding:
            const EdgeInsets.all(5), // Add padding to shrink the seat sizes
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.green : Colors.blue,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
