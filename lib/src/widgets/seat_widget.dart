import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/seat.dart';
import '../models/seat_status.dart';

/// Widget to display individual seat with modern UI
class SeatWidget extends StatelessWidget {
  /// The seat data to display
  final Seat seat;

  /// Callback when seat is tapped
  final VoidCallback? onTap;

  /// Size of the seat widget
  final double size;

  /// Whether to show seat number
  final bool showSeatNumber;

  /// Whether to show border on seat
  final bool showBorder;

  const SeatWidget(
      {super.key,
      required this.seat,
      this.onTap,
      this.size = 30,
      this.showSeatNumber = true,
      this.showBorder = false});

  @override
  Widget build(BuildContext context) {
    // Determine colors based on seat status
    Color backgroundColor;
    Color borderColor;
    Color textColor;

    switch (seat.status) {
      case SeatStatus.available:
        backgroundColor = Colors.black.withValues(alpha: 0.5);
        borderColor = Colors.grey[400]!;
        textColor = Colors.grey[800]!;
        break;
      case SeatStatus.selected:
        backgroundColor = Colors.blue;
        borderColor = Colors.blue[700]!;
        textColor = Colors.white;
        break;
      case SeatStatus.booked:
        backgroundColor = Colors.red[400]!;
        borderColor = Colors.red[200]!;
        textColor = Colors.white;
        break;
      case SeatStatus.unavailable:
        backgroundColor = Colors.grey[400]!;
        borderColor = Colors.grey[300]!;
        textColor = Colors.grey[600]!;
        break;
      case SeatStatus.driver:
        backgroundColor = Colors.transparent;
        borderColor = Colors.transparent;
        textColor = Colors.grey[600]!;
        break;
    }

    return GestureDetector(
        onTap: seat.status.isSelectable || seat.status == SeatStatus.selected
            ? onTap
            : null,
        child: Container(
          padding: !showBorder
              ? null
              : const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: !showBorder
              ? null
              : BoxDecoration(
                  color: seat.status == SeatStatus.selected
                      ? backgroundColor.withValues(alpha: 0.2)
                      : null,
                  border: Border.all(color: borderColor, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
          child: seat.status == SeatStatus.driver
              ? SvgPicture.asset(
                  'assets/svg/driver.svg',
                  width: showBorder ? size + 25 : size - 6,
                  height: showBorder ? size + 25 : size - 6,
                  colorFilter: ColorFilter.mode(
                    textColor,
                    BlendMode.srcIn,
                  ),
                  package: 'shitead',
                )
              : SvgPicture.asset(
                  'assets/svg/seat.svg',
                  width: !showBorder ? size - 6 : size,
                  height: !showBorder ? size - 6 : size,
                  // color: backgroundColor,
                  colorFilter: ColorFilter.mode(
                    backgroundColor,
                    BlendMode.srcIn,
                  ),
                  package: 'shitead',
                ),
        ));
  }
}
