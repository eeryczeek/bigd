import 'package:flutter/material.dart';
import 'package:frontend/models.dart';

class SeatWidget extends StatefulWidget {
  final Seat seat;
  final ValueChanged<bool> onSelected;

  const SeatWidget({
    super.key,
    required this.seat,
    required this.onSelected,
  });

  @override
  _SeatWidgetState createState() => _SeatWidgetState();
}

class _SeatWidgetState extends State<SeatWidget> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
        widget.onSelected(isSelected);
      },
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: widget.seat.isReserved
              ? Theme.of(context).colorScheme.secondary
              : isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.tertiary,
          border: Border.all(
            color: widget.seat.isReserved
                ? Theme.of(context).colorScheme.secondary
                : isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.tertiary,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
