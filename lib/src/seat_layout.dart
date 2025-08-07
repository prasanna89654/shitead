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

  /// Whether to show the legend section
  final bool showLegend;

  /// Whether to show the selection summary
  final bool showSelectionSummary;

  /// Legend section title
  final String legendTitle;

  /// Bus layout section title
  final String busLayoutTitle;

  /// Card padding for sections
  final EdgeInsets cardPadding;

  /// Section spacing between cards
  final double sectionSpacing;

  /// Legend item spacing
  final double legendItemSpacing;

  /// Legend run spacing (vertical spacing in wrap)
  final double legendRunSpacing;

  /// Legend title-content spacing
  final double legendTitleSpacing;

  /// Bus layout title-content spacing
  final double busLayoutTitleSpacing;

  /// Top row spacing (between top row and main seating)
  final double topRowSpacing;

  /// Row spacing in main seating area
  final double rowSpacing;

  /// Aisle width factor (multiplied by seat size)
  final double aisleWidthFactor;

  /// Whether to show aisle indicators
  final bool showAisleIndicators;

  /// Aisle indicator icon
  final IconData? aisleIndicatorIcon;

  /// Aisle indicator size
  final double aisleIndicatorSize;

  /// Legend icon size
  final double legendIconSize;

  /// Whether to show seat numbers in legend
  final bool showLegendSeatNumbers;

  /// Selection summary icon
  final IconData? selectionSummaryIcon;

  /// Card elevation
  final double cardElevation;

  /// Card margin
  final EdgeInsets? cardMargin;

  /// Custom text styles
  final TextStyle? legendTitleStyle;
  final TextStyle? busLayoutTitleStyle;
  final TextStyle? legendItemStyle;
  final TextStyle? selectionSummaryStyle;

  /// Custom colors
  final Color? legendCardColor;
  final Color? busLayoutCardColor;
  final Color? selectionSummaryCardColor;
  final Color? aisleIndicatorColor;
  final Color? aisleBorderColor;

  /// Border configurations
  final double aisleBorderWidth;
  final double aisleBorderOpacity;

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
    this.showLegend = true,
    this.showSelectionSummary = true,
    this.legendTitle = 'Seat Legend',
    this.busLayoutTitle = 'Bus Layout',
    this.cardPadding = const EdgeInsets.all(16),
    this.sectionSpacing = 16,
    this.legendItemSpacing = 16,
    this.legendRunSpacing = 12,
    this.legendTitleSpacing = 12,
    this.busLayoutTitleSpacing = 16,
    this.topRowSpacing = 16,
    this.rowSpacing = 8,
    this.aisleWidthFactor = 1.0,
    this.showAisleIndicators = true,
    this.aisleIndicatorIcon = Icons.more_vert,
    this.aisleIndicatorSize = 16,
    this.legendIconSize = 24,
    this.showLegendSeatNumbers = false,
    this.selectionSummaryIcon = Icons.check_circle,
    this.cardElevation = 1.0,
    this.cardMargin,
    this.legendTitleStyle,
    this.busLayoutTitleStyle,
    this.legendItemStyle,
    this.selectionSummaryStyle,
    this.legendCardColor,
    this.busLayoutCardColor,
    this.selectionSummaryCardColor,
    this.aisleIndicatorColor,
    this.aisleBorderColor,
    this.aisleBorderWidth = 1.0,
    this.aisleBorderOpacity = 0.3,
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
        if (widget.showLegend)
          SizedBox(
            width: double.infinity,
            child: Card(
              elevation: widget.cardElevation,
              margin: widget.cardMargin,
              color: widget.legendCardColor,
              child: Padding(
                padding: widget.cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.legendTitle,
                      style: widget.legendTitleStyle ??
                          theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: widget.legendTitleSpacing),
                    Wrap(
                      spacing: widget.legendItemSpacing,
                      runSpacing: widget.legendRunSpacing,
                      children: [
                        _buildLegendItem(
                            context, SeatStatus.available, 'Available'),
                        _buildLegendItem(
                            context, SeatStatus.selected, 'Selected'),
                        _buildLegendItem(context, SeatStatus.booked, 'Booked'),
                        _buildLegendItem(
                            context, SeatStatus.unavailable, 'Unavailable'),
                        if (widget.showDriverSeat)
                          _buildLegendItem(
                              context, SeatStatus.driver, 'Driver'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

        if (widget.showLegend) SizedBox(height: widget.sectionSpacing),

        // Bus Layout
        Card(
          elevation: widget.cardElevation,
          margin: widget.cardMargin,
          color: widget.busLayoutCardColor,
          child: Padding(
            padding: widget.cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.busLayoutTitle,
                  style: widget.busLayoutTitleStyle ??
                      theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: widget.busLayoutTitleSpacing),
                _buildBusLayout(),
              ],
            ),
          ),
        ),

        // Selection summary
        if (widget.showSelectionSummary && _selectedSeatIds.isNotEmpty) ...[
          SizedBox(height: widget.sectionSpacing),
          Card(
            elevation: widget.cardElevation,
            margin: widget.cardMargin,
            color: widget.selectionSummaryCardColor ??
                colorScheme.primaryContainer,
            child: Padding(
              padding: widget.cardPadding,
              child: Row(
                children: [
                  if (widget.selectionSummaryIcon != null)
                    Icon(
                      widget.selectionSummaryIcon,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  if (widget.selectionSummaryIcon != null)
                    const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Selected seats: ${_selectedSeatIds.map((id) => _seats.firstWhere((s) => s.id == id).seatNumber).join(', ')}',
                      style: widget.selectionSummaryStyle ??
                          theme.textTheme.bodyMedium?.copyWith(
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
          size: widget.legendIconSize,
          showSeatNumber: widget.showLegendSeatNumbers,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style:
              widget.legendItemStyle ?? Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }

  Widget _buildBusLayout() {
    final passengerSeats = _seats.where((seat) => !seat.isDriver).toList();
    final driverSeat = widget.showDriverSeat
        ? _seats.firstWhere((seat) => seat.isDriver, orElse: () => _seats.first)
        : null;

    return Column(
      children: [
        // Top row: 2 seats on left + empty space + driver seat on right
        _buildTopRow(passengerSeats, driverSeat),

        SizedBox(height: widget.topRowSpacing),

        // Main seating area with aisle
        _buildMainSeatingArea(passengerSeats),
      ],
    );
  }

  Widget _buildTopRow(List<Seat> passengerSeats, Seat? driverSeat) {
    // Get first 2 passenger seats for top left
    final topLeftSeats = passengerSeats.take(2).toList();

    return Row(
      children: [
        // Top left seats (2 seats)
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: topLeftSeats.map((seat) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: widget.seatSpacing),
                child: SeatWidget(
                  seat: seat,
                  showBorder: true,
                  onTap: () => _onSeatTapped(seat),
                  size: widget.seatSize,
                ),
              );
            }).toList(),
          ),
        ),

        // Empty space in middle
        const Expanded(flex: 1, child: SizedBox()),

        // Driver seat on top right
        if (widget.showDriverSeat && driverSeat != null)
          Expanded(
            flex: 2,
            child: Center(
              child: SeatWidget(
                seat: driverSeat,
                showBorder: true,
                onTap: () => _onSeatTapped(driverSeat),
                size: 50,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMainSeatingArea(List<Seat> passengerSeats) {
    // Skip first 2 seats (they're in top row)
    final mainSeats = passengerSeats.skip(2).toList();
    final rows = <List<Seat>>[];

    // Group remaining seats by rows of 4 (2 left + 2 right)
    for (int i = 0; i < mainSeats.length; i += 4) {
      final end = (i + 4).clamp(0, mainSeats.length);
      rows.add(mainSeats.sublist(i, end));
    }

    return Column(
      children: rows.map((row) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: widget.rowSpacing / 2),
          child: _buildBusRow(row),
        );
      }).toList(),
    );
  }

  Widget _buildBusRow(List<Seat> rowSeats) {
    // Split seats: first 2 go to left, next 2 go to right
    final leftSeats = rowSeats.take(2).toList();
    final rightSeats = rowSeats.skip(2).take(2).toList();

    return Row(
      children: [
        // Left side seats
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: leftSeats.map((seat) {
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
        ),

        // Aisle (empty space)
        Expanded(
          flex: (widget.aisleWidthFactor * 1).round(),
          child: Container(
            height: widget.seatSize,
            decoration: BoxDecoration(
              border: Border.symmetric(
                vertical: BorderSide(
                  color: widget.aisleBorderColor ??
                      Theme.of(context)
                          .colorScheme
                          .outline
                          .withOpacity(widget.aisleBorderOpacity),
                  width: widget.aisleBorderWidth,
                ),
              ),
            ),
            child: widget.showAisleIndicators
                ? Center(
                    child: Icon(
                      widget.aisleIndicatorIcon,
                      color: widget.aisleIndicatorColor ??
                          Theme.of(context)
                              .colorScheme
                              .outline
                              .withOpacity(0.5),
                      size: widget.aisleIndicatorSize,
                    ),
                  )
                : null,
          ),
        ),

        // Right side seats
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: rightSeats.map((seat) {
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
        ),
      ],
    );
  }
}
