import 'package:flutter/material.dart';
import 'package:shitead/shitead.dart';

/// Quick demonstration of the Shitead package
///
/// This example shows how to:
/// 1. Create a basic seat layout
/// 2. Handle seat selection
/// 3. Configure different seat statuses
/// 4. Add custom metadata and passenger information
void main() {
  runApp(const QuickDemo());
}

class QuickDemo extends StatelessWidget {
  const QuickDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shitead Quick Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const QuickDemoHome(),
    );
  }
}

class QuickDemoHome extends StatefulWidget {
  const QuickDemoHome({super.key});

  @override
  State<QuickDemoHome> createState() => _QuickDemoHomeState();
}

class _QuickDemoHomeState extends State<QuickDemoHome> {
  List<Seat> selectedSeats = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('🚌 Bus Seat Selection'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.directions_bus,
                      size: 32,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Select your preferred seats for the journey',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Seat Layout
            SeatLayout(
              numberOfSeats: 24,
              seatsPerRow: 4,
              showDriverSeat: true,
              allowMultipleSelection: true,
              seatSize: 50,
              seatSpacing: 10,

              // Some seats are already booked
              bookedSeats: const ['seat_2', 'seat_8', 'seat_15', 'seat_21'],

              // One seat is out of order
              unavailableSeats: const ['seat_12'],

              // Add passenger names for booked seats
              passengerNames: const {
                'driver': 'Mike Wilson',
                'seat_2': 'Sarah Connor',
                'seat_8': 'John Smith',
                'seat_15': 'Emma Davis',
                'seat_21': 'Alex Johnson',
              },

              // Add some metadata
              seatMetadata: const {
                'seat_2': {
                  'booking_ref': 'BK2024001',
                  'ticket_type': 'Premium',
                  'price': 75.0,
                },
                'seat_8': {
                  'booking_ref': 'BK2024002',
                  'ticket_type': 'Standard',
                  'price': 50.0,
                },
                'seat_12': {
                  'reason': 'Seat mechanism repair needed',
                  'estimated_fix': 'Next maintenance cycle',
                },
                'seat_15': {
                  'booking_ref': 'BK2024003',
                  'ticket_type': 'Student',
                  'price': 35.0,
                },
                'seat_21': {
                  'booking_ref': 'BK2024004',
                  'ticket_type': 'Senior',
                  'price': 40.0,
                },
              },

              onSeatSelectionChanged: (seats) {
                setState(() {
                  selectedSeats = seats;
                });
              },
            ),

            const SizedBox(height: 24),

            // Booking summary
            if (selectedSeats.isNotEmpty) ...[
              Card(
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.confirmation_num,
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Booking Summary',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const Divider(),
                      Text(
                        'Selected Seats: ${selectedSeats.map((s) => s.seatNumber).join(', ')}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Total Seats: ${selectedSeats.length}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                            ),
                      ),
                      Text(
                        'Estimated Price: \$${(selectedSeats.length * 50).toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          selectedSeats.clear();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Selection cleared')),
                        );
                      },
                      child: const Text('Clear Selection'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Booking confirmed for seats: ${selectedSeats.map((s) => s.seatNumber).join(', ')}',
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                        );
                      },
                      child: const Text('Confirm Booking'),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 24),

            // Instructions
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📱 How to use:',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    const Text('• Tap on available seats to select them'),
                    const Text('• Tap on selected seats to deselect them'),
                    const Text(
                        '• Tap on any seat to view detailed information'),
                    const Text('• Use the legend to understand seat statuses'),
                    const Text('• Multiple seats can be selected at once'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
