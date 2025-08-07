import 'package:flutter/material.dart';
import '../models/seat.dart';
import '../models/seat_status.dart';
import 'seat_widget.dart';

/// Widget to display seat legend with different statuses
class SeatLegend extends StatelessWidget {
  const SeatLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Seat Legend',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          _buildLegendItem(
            context,
            SeatStatus.available,
            'Available',
            Colors.grey[100]!,
            Colors.grey[400]!,
          ),
          const SizedBox(height: 8),
          _buildLegendItem(
            context,
            SeatStatus.selected,
            'Selected',
            Colors.blue[500]!,
            Colors.blue[700]!,
          ),
          const SizedBox(height: 8),
          _buildLegendItem(
            context,
            SeatStatus.booked,
            'Booked',
            Colors.red[400]!,
            Colors.red[600]!,
          ),
          const SizedBox(height: 8),
          _buildLegendItem(
            context,
            SeatStatus.unavailable,
            'Unavailable',
            Colors.grey[300]!,
            Colors.grey[500]!,
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(
    BuildContext context,
    SeatStatus status,
    String label,
    Color backgroundColor,
    Color borderColor,
  ) {
    return Row(
      children: [
        SeatWidget(
          seat: Seat(
            id: 'legend',
            seatNumber: '',
            status: status,
            row: 0,
            column: 0,
          ),
          size: 30,
          showSeatNumber: false,
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
