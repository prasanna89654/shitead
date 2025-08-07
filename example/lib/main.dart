import 'package:flutter/material.dart';
import 'package:shitead/shitead.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seat Layout Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SeatLayoutDemo(),
    );
  }
}

class SeatLayoutDemo extends StatefulWidget {
  const SeatLayoutDemo({super.key});

  @override
  State<SeatLayoutDemo> createState() => _SeatLayoutDemoState();
}

class _SeatLayoutDemoState extends State<SeatLayoutDemo> {
  List<Seat> selectedSeats = [];
  int numberOfSeats = 20;
  int seatsPerRow = 4;
  bool allowMultipleSelection = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Seat Layout'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: SeatLayout(
          numberOfSeats: numberOfSeats,
          seatsPerRow: seatsPerRow,
          showDriverSeat: true,
          allowMultipleSelection: allowMultipleSelection,
          onSeatSelectionChanged: (seats) {
            setState(() {
              selectedSeats = seats;
            });
          },
          seatSize: 30,
          // Example of pre-booked seats
          bookedSeats: const ['seat_3', 'seat_7'],
          // Example of unavailable seats
          unavailableSeats: const ['seat_15'],
          // Example of custom passenger names
          passengerNames: const {
            'driver': 'John Driver',
            'seat_3': 'Alice Smith',
            'seat_7': 'Bob Johnson',
          },
          // Example of custom metadata
          seatMetadata: const {
            'seat_3': {'booking_id': 'BK001', 'price': 50.0},
            'seat_7': {'booking_id': 'BK002', 'price': 45.0},
            'seat_15': {'reason': 'Maintenance required'},
          },
        ),
      ),
    );
  }
}
