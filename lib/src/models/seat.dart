import 'seat_status.dart';

/// Model representing a single seat in the layout
class Seat {
  /// Unique identifier for the seat
  final String id;

  /// Seat number displayed to user
  final String seatNumber;

  /// Seat Price
  final double? price;

  /// Current status of the seat
  SeatStatus status;

  /// Row number in the layout
  final int row;

  /// Column number in the layout
  final int column;

  /// Whether this is a driver seat
  final bool isDriver;

  /// Optional passenger information
  final String? passengerName;

  /// Optional additional information about the seat
  final Map<String, dynamic>? metadata;

  Seat({
    required this.id,
    required this.seatNumber,
    this.price,
    required this.status,
    required this.row,
    required this.column,
    this.isDriver = false,
    this.passengerName,
    this.metadata,
  });

  /// Creates a copy of this seat with updated properties
  Seat copyWith({
    String? id,
    String? seatNumber,
    SeatStatus? status,
    int? row,
    int? column,
    bool? isDriver,
    String? passengerName,
    Map<String, dynamic>? metadata,
  }) {
    return Seat(
      id: id ?? this.id,
      seatNumber: seatNumber ?? this.seatNumber,
      status: status ?? this.status,
      row: row ?? this.row,
      column: column ?? this.column,
      isDriver: isDriver ?? this.isDriver,
      passengerName: passengerName ?? this.passengerName,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Seat && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Seat(id: $id, seatNumber: $seatNumber, status: $status, isDriver: $isDriver)';
  }
}
