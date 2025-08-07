import 'package:flutter/material.dart';
import '../models/seat.dart';
import '../models/seat_status.dart';
import 'seat_widget.dart';
import 'seat_detail_modal.dart';

/// Main widget that displays seat layout with legend
class SeatLayoutWithLegend extends StatefulWidget {
  final List<List<Seat?>> seatLayout;
  final Function(List<Seat>)? onProceed;
  final double seatSize;
  final bool showLegend;

  const SeatLayoutWithLegend({
    super.key,
    required this.seatLayout,
    this.onProceed,
    this.seatSize = 50,
    this.showLegend = true,
  });

  @override
  State<SeatLayoutWithLegend> createState() => _SeatLayoutWithLegendState();
}

class _SeatLayoutWithLegendState extends State<SeatLayoutWithLegend> {
  final List<Seat> _selectedSeats = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Select Seats'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        shadowColor: Colors.black26,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Bus body
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 24.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      border: Border.all(color: Colors.grey[300]!, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: widget.seatLayout.map((row) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: row.map((seat) {
                              if (seat == null) {
                                return SizedBox(width: widget.seatSize);
                              }
                              return SeatWidget(
                                seat: seat,
                                size: widget.seatSize,
                                onTap: () => _onSeatTapped(seat),
                              );
                            }).toList(),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  void _onSeatTapped(Seat seat) {
    if (seat.status == SeatStatus.booked ||
        seat.status == SeatStatus.unavailable ||
        seat.status == SeatStatus.driver) {
      return; // Cannot interact with these seats
    }

    SeatDetailModal.show(
      context,
      seat,
      onSelect: () {
        if (seat.status == SeatStatus.available) {
          setState(() {
            seat.status = SeatStatus.selected;
            _selectedSeats.add(seat);
          });
        }
      },
      onDeselect: () {
        if (seat.status == SeatStatus.selected) {
          setState(() {
            seat.status = SeatStatus.available;
            _selectedSeats.remove(seat);
          });
        }
      },
    );
  }

  Widget _buildBottomBar() {
    if (_selectedSeats.isEmpty) {
      return const SizedBox.shrink();
    }

    double totalPrice =
        _selectedSeats.fold(0.0, (sum, seat) => sum + (seat.price ?? 0.0));
    String selectedSeatNumbers =
        _selectedSeats.map((s) => s.seatNumber).join(', ');

    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 16, 16, 16 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${_selectedSeats.length} Seat(s) Selected',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  'Seats: $selectedSeatNumbers',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: () => widget.onProceed?.call(_selectedSeats),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Row(
              children: [
                Text(
                  'Proceed \$${totalPrice.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_rounded, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
