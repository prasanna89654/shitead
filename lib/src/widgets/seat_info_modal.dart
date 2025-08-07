import 'package:flutter/material.dart';
import '../models/seat.dart';
import '../models/seat_status.dart';

/// Modal bottom sheet that displays detailed seat information
class SeatInfoModal extends StatelessWidget {
  /// The seat to display information for
  final Seat seat;

  /// Callback when seat selection changes
  final Function(Seat)? onSeatToggle;

  const SeatInfoModal({
    super.key,
    required this.seat,
    this.onSeatToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
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
                color: colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Seat number and status
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _getStatusColor(seat.status, colorScheme),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getStatusColor(seat.status, colorScheme),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: seat.isDriver
                      ? Icon(
                          Icons.drive_eta,
                          color: colorScheme.onTertiary,
                          size: 24,
                        )
                      : Text(
                          seat.seatNumber,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color:
                                _getStatusTextColor(seat.status, colorScheme),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      seat.isDriver ? 'Driver Seat' : 'Seat ${seat.seatNumber}',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(seat.status, colorScheme),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        seat.status.displayName,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: _getStatusTextColor(seat.status, colorScheme),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Seat details
          _buildDetailRow(
            context,
            'Position',
            'Row ${seat.row}, Column ${seat.column}',
          ),

          if (seat.passengerName != null) ...[
            const SizedBox(height: 12),
            _buildDetailRow(
              context,
              'Passenger',
              seat.passengerName!,
            ),
          ],

          if (seat.metadata != null && seat.metadata!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Additional Information',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...seat.metadata!.entries.map(
              (entry) => _buildDetailRow(
                context,
                entry.key,
                entry.value.toString(),
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Action buttons
          if (!seat.isDriver &&
              seat.status != SeatStatus.booked &&
              seat.status != SeatStatus.unavailable)
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  final newStatus = seat.status == SeatStatus.selected
                      ? SeatStatus.available
                      : SeatStatus.selected;
                  final updatedSeat = seat.copyWith(status: newStatus);
                  onSeatToggle?.call(updatedSeat);
                  Navigator.of(context).pop();
                },
                child: Text(
                  seat.status == SeatStatus.selected
                      ? 'Deselect Seat'
                      : 'Select Seat',
                ),
              ),
            ),

          const SizedBox(height: 8),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ),

          // Safe area padding
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(SeatStatus status, ColorScheme colorScheme) {
    switch (status) {
      case SeatStatus.available:
        return colorScheme.surface;
      case SeatStatus.selected:
        return colorScheme.primary;
      case SeatStatus.booked:
        return colorScheme.error;
      case SeatStatus.unavailable:
        return colorScheme.surfaceContainerHighest;
      case SeatStatus.driver:
        return colorScheme.tertiary;
    }
  }

  Color _getStatusTextColor(SeatStatus status, ColorScheme colorScheme) {
    switch (status) {
      case SeatStatus.available:
        return colorScheme.onSurface;
      case SeatStatus.selected:
        return colorScheme.onPrimary;
      case SeatStatus.booked:
        return colorScheme.onError;
      case SeatStatus.unavailable:
        return colorScheme.onSurfaceVariant;
      case SeatStatus.driver:
        return colorScheme.onTertiary;
    }
  }
}
