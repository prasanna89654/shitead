/// Enumeration representing the different states a seat can be in
enum SeatStatus {
  /// Seat is available for booking
  available,

  /// Seat is currently selected by the user
  selected,

  /// Seat is already booked by someone else
  booked,

  /// Seat is out of order or maintenance
  unavailable,

  /// Driver's seat (special status)
  driver,
}

/// Extension to provide color and display properties for seat status
extension SeatStatusExtension on SeatStatus {
  /// Returns the display name for the seat status
  String get displayName {
    switch (this) {
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

  /// Returns whether the seat can be selected
  bool get isSelectable {
    switch (this) {
      case SeatStatus.available:
        return true;
      case SeatStatus.selected:
      case SeatStatus.booked:
      case SeatStatus.unavailable:
      case SeatStatus.driver:
        return false;
    }
  }
}
