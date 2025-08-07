# Shitead - Flutter Seat Layout Package

A modern Flutter package for building interactive passenger seat layouts with driver seat, selection functionality, and detailed seat information modals.

## Features

- 🚗 **Driver Seat Support**: Optional driver seat with distinct styling
- 🪑 **Customizable Layout**: Configure number of seats, seats per row, and layout
- 🎯 **Interactive Selection**: Touch seats to select/deselect with visual feedback
- 📱 **Modern UI**: Material Design 3 compliant with smooth animations
- 📋 **Detailed Info Modals**: Bottom sheet modals showing seat information
- 🔧 **Flexible Configuration**: Pre-booked seats, unavailable seats, custom metadata
- 🎨 **Themeable**: Respects app's color scheme and theme
- ✅ **Well Tested**: Comprehensive test coverage

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  shitead: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Example

```dart
import 'package:flutter/material.dart';
import 'package:shitead/shitead.dart';

class SeatSelectionScreen extends StatefulWidget {
  @override
  _SeatSelectionScreenState createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  List<Seat> selectedSeats = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Seats')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SeatLayout(
          numberOfSeats: 20,
          seatsPerRow: 4,
          showDriverSeat: true,
          onSeatSelectionChanged: (seats) {
            setState(() {
              selectedSeats = seats;
            });
          },
        ),
      ),
    );
  }
}
```

### Advanced Configuration

```dart
SeatLayout(
  numberOfSeats: 30,
  seatsPerRow: 4,
  showDriverSeat: true,
  allowMultipleSelection: true,
  seatSize: 55,
  seatSpacing: 10,

  // Pre-select some seats
  initialSelectedSeats: ['seat_5', 'seat_6'],

  // Mark some seats as booked
  bookedSeats: ['seat_1', 'seat_15', 'seat_20'],

  // Mark some seats as unavailable
  unavailableSeats: ['seat_10'],

  // Add passenger names
  passengerNames: {
    'driver': 'John Doe',
    'seat_1': 'Alice Smith',
    'seat_15': 'Bob Johnson',
  },

  // Add custom metadata
  seatMetadata: {
    'seat_1': {
      'booking_id': 'BK001',
      'price': 50.0,
      'meal_preference': 'Vegetarian'
    },
    'seat_10': {
      'reason': 'Maintenance required',
      'estimated_fix': '2024-01-15'
    },
  },

  onSeatSelectionChanged: (selectedSeats) {
    print('Selected seats: ${selectedSeats.map((s) => s.seatNumber).join(', ')}');
  },
)
```

## Seat Status Types

- **Available**: Open for selection
- **Selected**: Currently selected by user
- **Booked**: Already taken by another passenger
- **Unavailable**: Out of order or maintenance
- **Driver**: Special driver seat

## Customization Options

### SeatLayout Properties

| Property                 | Type                                 | Default      | Description                    |
| ------------------------ | ------------------------------------ | ------------ | ------------------------------ |
| `numberOfSeats`          | `int`                                | **Required** | Number of passenger seats      |
| `seatsPerRow`            | `int`                                | `4`          | Seats per row in layout        |
| `showDriverSeat`         | `bool`                               | `true`       | Whether to show driver seat    |
| `allowMultipleSelection` | `bool`                               | `true`       | Allow selecting multiple seats |
| `seatSize`               | `double`                             | `50`         | Size of individual seats       |
| `seatSpacing`            | `double`                             | `8`          | Spacing between seats          |
| `initialSelectedSeats`   | `List<String>?`                      | `null`       | Initially selected seat IDs    |
| `bookedSeats`            | `List<String>?`                      | `null`       | Pre-booked seat IDs            |
| `unavailableSeats`       | `List<String>?`                      | `null`       | Unavailable seat IDs           |
| `passengerNames`         | `Map<String, String>?`               | `null`       | Custom passenger names         |
| `seatMetadata`           | `Map<String, Map<String, dynamic>>?` | `null`       | Custom seat metadata           |
| `onSeatSelectionChanged` | `Function(List<Seat>)?`              | `null`       | Selection change callback      |

### Seat Model Properties

| Property        | Type                    | Description                 |
| --------------- | ----------------------- | --------------------------- |
| `id`            | `String`                | Unique seat identifier      |
| `seatNumber`    | `String`                | Display seat number         |
| `status`        | `SeatStatus`            | Current seat status         |
| `row`           | `int`                   | Row position                |
| `column`        | `int`                   | Column position             |
| `isDriver`      | `bool`                  | Whether this is driver seat |
| `passengerName` | `String?`               | Passenger name (if any)     |
| `metadata`      | `Map<String, dynamic>?` | Additional seat data        |

## Screenshots

## Example App

Check out the example app in the `example/` directory for a complete implementation with configuration options.

```bash
cd example
flutter run
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes.
