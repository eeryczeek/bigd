import 'package:flutter/material.dart';
import 'package:frontend/models.dart';

class SeatWidget extends StatefulWidget {
  final Seat seat;
  final Function(bool) onSelected;
  final String? reservedBy;

  const SeatWidget({
    Key? key,
    required this.seat,
    required this.onSelected,
    this.reservedBy,
  }) : super(key: key);

  @override
  _SeatWidgetState createState() => _SeatWidgetState();
}

class _SeatWidgetState extends State<SeatWidget> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.seat.isReserved) {
          return;
        }
        setState(() {
          isSelected = !isSelected;
        });
        widget.onSelected(isSelected);
      },
      child: Tooltip(
        message: widget.seat.isReserved
            ? 'Reserved by ${widget.reservedBy}'
            : 'Available',
        child: SizedBox(
          width: 64,
          height: 64,
          child: Center(
            child: Container(
              width: 56,
              height: 56,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: widget.seat.isReserved
                    ? Colors.grey.shade600
                    : Theme.of(context).colorScheme.secondary,
                border: Border.all(
                  color: widget.seat.isReserved
                      ? Colors.grey.shade600
                      : isSelected
                          ? Theme.of(context).colorScheme.tertiary
                          : Theme.of(context).colorScheme.secondary,
                  width: 4,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
