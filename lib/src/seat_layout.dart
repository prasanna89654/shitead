import 'package:flutter/material.dart';
import 'models/seat.dart';
import 'models/seat_status.dart';
import 'widgets/seat_widget.dart';
import 'widgets/seat_info_modal.dart';

/// Main widget for displaying passenger seat layout
class SeatLayout extends StatefulWidget {
  /// Number of passenger seats to display
  final int numberOfSeats;

  /// Number of seats per row
  final int seatsPerRow;

  /// Whether to show driver seat
  final bool showDriverSeat;

  /// Callback when seat selection changes
  final Function(List<Seat>)? onSeatSelectionChanged;

  /// Initially selected seat IDs
  final List<String>? initialSelectedSeats;

  /// Pre-booked seat IDs
  final List<String>? bookedSeats;

  /// Unavailable seat IDs
  final List<String>? unavailableSeats;

  /// Custom seat metadata
  final Map<String, Map<String, dynamic>>? seatMetadata;

  /// Custom passenger names
  final Map<String, String>? passengerNames;

  /// Size of individual seats
  final double seatSize;

  /// Spacing between seats
  final double seatSpacing;

  /// Whether to allow multiple seat selection
  final bool allowMultipleSelection;

  const SeatLayout({
    super.key,
    required this.numberOfSeats,
    this.seatsPerRow = 4,
    this.showDriverSeat = true,
    this.onSeatSelectionChanged,
    this.initialSelectedSeats,
    this.bookedSeats,
    this.unavailableSeats,
    this.seatMetadata,
    this.passengerNames,
    this.seatSize = 50,
    this.seatSpacing = 8,
    this.allowMultipleSelection = true,
  });

  @override
  State<SeatLayout> createState() => _SeatLayoutState();
}

class _SeatLayoutState extends State<SeatLayout> {
  late List<Seat> _seats;
  late List<String> _selectedSeatIds;

  @override
  void initState() {
    super.initState();
    _selectedSeatIds = List.from(widget.initialSelectedSeats ?? []);
    _generateSeats();
  }

  @override
  void didUpdateWidget(SeatLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.numberOfSeats != widget.numberOfSeats ||
        oldWidget.seatsPerRow != widget.seatsPerRow ||
        oldWidget.showDriverSeat != widget.showDriverSeat) {
      _generateSeats();
    }
  }

  void _generateSeats() {
    _seats = [];

    // Add driver seat if enabled
    if (widget.showDriverSeat) {
      _seats.add(
        Seat(
          id: 'driver',
          seatNumber: 'D',
          status: SeatStatus.driver,
          row: 0,
          column: 0,
          isDriver: true,
          passengerName: widget.passengerNames?['driver'],
          metadata: widget.seatMetadata?['driver'],
        ),
      );
    }

    // Add passenger seats
    for (int i = 0; i < widget.numberOfSeats; i++) {
      final seatId = 'seat_${i + 1}';
      final seatNumber = '${i + 1}';
      final row = (i ~/ widget.seatsPerRow) + (widget.showDriverSeat ? 1 : 0);
      final column = i % widget.seatsPerRow;

      SeatStatus status = SeatStatus.available;

      if (widget.bookedSeats?.contains(seatId) == true) {
        status = SeatStatus.booked;
      } else if (widget.unavailableSeats?.contains(seatId) == true) {
        status = SeatStatus.unavailable;
      } else if (_selectedSeatIds.contains(seatId)) {
        status = SeatStatus.selected;
      }

      _seats.add(
        Seat(
          id: seatId,
          seatNumber: seatNumber,
          status: status,
          row: row,
          column: column,
          passengerName: widget.passengerNames?[seatId],
          metadata: widget.seatMetadata?[seatId],
        ),
      );
    }
  }

  void _onSeatTapped(Seat seat) {
    if (seat.isDriver) {
      _showSeatInfo(seat);
      return;
    }

    if (seat.status == SeatStatus.booked ||
        seat.status == SeatStatus.unavailable) {
      _showSeatInfo(seat);
      return;
    }

    setState(() {
      if (seat.status == SeatStatus.selected) {
        // Deselect seat
        _selectedSeatIds.remove(seat.id);
        _updateSeatStatus(seat.id, SeatStatus.available);
      } else {
        // Select seat
        if (!widget.allowMultipleSelection) {
          // Deselect all other seats
          for (final seatId in _selectedSeatIds) {
            _updateSeatStatus(seatId, SeatStatus.available);
          }
          _selectedSeatIds.clear();
        }

        _selectedSeatIds.add(seat.id);
        _updateSeatStatus(seat.id, SeatStatus.selected);
      }
    });

    _notifySelectionChanged();
  }

  void _updateSeatStatus(String seatId, SeatStatus newStatus) {
    final seatIndex = _seats.indexWhere((s) => s.id == seatId);
    if (seatIndex >= 0) {
      _seats[seatIndex] = _seats[seatIndex].copyWith(status: newStatus);
    }
  }

  void _notifySelectionChanged() {
    final selectedSeats =
        _seats.where((seat) => seat.status == SeatStatus.selected).toList();
    widget.onSeatSelectionChanged?.call(selectedSeats);
  }

  void _showSeatInfo(Seat seat) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SeatInfoModal(
        seat: seat,
        onSeatToggle: seat.isDriver ? null : _onSeatToggled,
      ),
    );
  }

  void _onSeatToggled(Seat updatedSeat) {
    setState(() {
      final seatIndex = _seats.indexWhere((s) => s.id == updatedSeat.id);
      if (seatIndex >= 0) {
        _seats[seatIndex] = updatedSeat;

        if (updatedSeat.status == SeatStatus.selected) {
          if (!widget.allowMultipleSelection) {
            // Deselect all other seats
            for (final seatId in _selectedSeatIds) {
              if (seatId != updatedSeat.id) {
                _updateSeatStatus(seatId, SeatStatus.available);
              }
            }
            _selectedSeatIds.clear();
          }
          _selectedSeatIds.add(updatedSeat.id);
        } else {
          _selectedSeatIds.remove(updatedSeat.id);
        }
      }
    });

    _notifySelectionChanged();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        // Legend
        SizedBox(
          width: double.infinity,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Seat Legend',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    children: [
                      _buildLegendItem(
                          context, SeatStatus.available, 'Available'),
                      _buildLegendItem(
                          context, SeatStatus.selected, 'Selected'),
                      _buildLegendItem(context, SeatStatus.booked, 'Booked'),
                      _buildLegendItem(
                          context, SeatStatus.unavailable, 'Unavailable'),
                      if (widget.showDriverSeat)
                        _buildLegendItem(context, SeatStatus.driver, 'Driver'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Passenger seats section
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Passenger Seats',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSeatGrid(),
              ],
            ),
          ),
        ),

        // Selection summary
        if (_selectedSeatIds.isNotEmpty) ...[
          const SizedBox(height: 16),
          Card(
            color: colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Selected seats: ${_selectedSeatIds.map((id) => _seats.firstWhere((s) => s.id == id).seatNumber).join(', ')}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
     
      ],
    );
  }

  Widget _buildLegendItem(
      BuildContext context, SeatStatus status, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SeatWidget(
          seat: Seat(
            id: 'legend_${status.name}',
            seatNumber: status == SeatStatus.driver ? 'D' : '1',
            status: status,
            row: 0,
            column: 0,
            isDriver: status == SeatStatus.driver,
          ),
          size: 24,
          showSeatNumber: false,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }

  Widget _buildSeatGrid() {
    final passengerSeats = _seats.where((seat) => !seat.isDriver).toList();
    final rows = <List<Seat>>[];

    // Group seats by row
    for (int i = 0; i < passengerSeats.length; i += widget.seatsPerRow) {
      final end = (i + widget.seatsPerRow).clamp(0, passengerSeats.length);
      rows.add(passengerSeats.sublist(i, end));
    }

    return Column(
      children: rows.map((row) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: widget.seatSpacing / 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.map((seat) {
              return Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: widget.seatSpacing / 2),
                child: SeatWidget(
                  seat: seat,
                  showBorder: true,
                  onTap: () => _onSeatTapped(seat),
                  size: widget.seatSize,
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}
