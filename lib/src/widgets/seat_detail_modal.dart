import 'package:flutter/material.dart';
import '../models/seat.dart';
import '../models/seat_status.dart';

/// Bottom modal sheet to show seat details
class SeatDetailModal extends StatelessWidget {
  final Seat seat;
  final VoidCallback? onSelect;
  final VoidCallback? onDeselect;

  const SeatDetailModal({
    super.key,
    required this.seat,
    this.onSelect,
    this.onDeselect,
  });

  static void show(
    BuildContext context,
    Seat seat, {
    VoidCallback? onSelect,
    VoidCallback? onDeselect,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SeatDetailModal(
        seat: seat,
        onSelect: onSelect,
        onDeselect: onDeselect,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Seat info
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _getSeatColor(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  seat.seatNumber,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Seat ${seat.seatNumber}',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Row ${seat.row + 1}, Column ${seat.column + 1}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getSeatColor().withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getStatusText(),
                        style: TextStyle(
                          color: _getSeatColor(),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Additional seat details
          if (seat.price != null) ...[
            _buildDetailRow('Price', '\$${seat.price!.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
          ],

          _buildDetailRow(
              'Position', 'Row ${seat.row + 1}, Seat ${seat.column + 1}'),

          const SizedBox(height: 24),

          // Action buttons
          if (seat.status == SeatStatus.available) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onSelect?.call();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[500],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Select Seat'),
              ),
            ),
          ] else if (seat.status == SeatStatus.selected) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onDeselect?.call();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[500],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Deselect Seat'),
              ),
            ),
          ],

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ),

          // Bottom padding for safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Color _getSeatColor() {
    switch (seat.status) {
      case SeatStatus.available:
        return Colors.grey[600]!;
      case SeatStatus.selected:
        return Colors.blue[500]!;
      case SeatStatus.booked:
        return Colors.red[400]!;
      case SeatStatus.unavailable:
        return Colors.grey[400]!;
      case SeatStatus.driver:
        return Colors.green[500]!;
    }
  }

  String _getStatusText() {
    switch (seat.status) {
      case SeatStatus.available:
        return 'Available';
      case SeatStatus.selected:
        return 'Selected';
      case SeatStatus.booked:
        return 'Booked';
      case SeatStatus.unavailable:
        return 'Unavailable';
      case SeatStatus.driver:
        return 'Driver';
    }
  }
}
