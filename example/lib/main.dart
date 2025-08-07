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
  final int numberOfSeats = 22;
  final bool allowMultipleSelection = true;
  final bool showLegend = true;
  final bool showSelectionSummary = true;
  final bool showAisleIndicators = true;
  final double seatSize = 25;
  final double seatSpacing = 8;
  final double aisleWidthFactor = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Seat Layout'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SeatLayout(
              numberOfSeats: numberOfSeats,
              seatsPerRow: 4,
              showDriverSeat: true,
              allowMultipleSelection: allowMultipleSelection,

              // Visual Customization
              seatSize: seatSize,
              seatSpacing: seatSpacing,
              showLegend: showLegend,
              showSelectionSummary: showSelectionSummary,

              // Layout Customization
              topRowSpacing: 20,
              rowSpacing: 12,
              aisleWidthFactor: aisleWidthFactor,
              showAisleIndicators: showAisleIndicators,
              aisleIndicatorIcon: Icons.more_vert,
              aisleIndicatorSize: 18,

              // Card Customization
              cardPadding: const EdgeInsets.all(20),
              sectionSpacing: 20,
              cardElevation: 2,

              // Legend Customization
              legendTitle: 'SEAT LEGEND',
              legendTitleSpacing: 20,
              legendIconSize: 28,
              legendItemSpacing: 20,
              legendRunSpacing: 16,
              showLegendSeatNumbers: true,

              // Bus Layout Customization
              busLayoutTitle: 'BUS SEATS',

              // Colors
              legendCardColor: Colors.white,
              busLayoutCardColor: Colors.white,
              aisleIndicatorColor: Colors.grey.shade600,
              aisleBorderColor: Colors.grey.shade400,
              aisleBorderWidth: 2,
              aisleBorderOpacity: 0.5,

              // Text Styles
              legendTitleStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              busLayoutTitleStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
              legendItemStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                // color: Colors.blue.shade700,
              ),

              // Selection callback
              onSeatSelectionChanged: (seats) {
                setState(() {
                  selectedSeats = seats;
                });
              },

              // Example data
              bookedSeats: const ['seat_3', 'seat_7', 'seat_19', 'seat_24'],
              unavailableSeats: const ['seat_15', 'seat_22'],
              passengerNames: const {
                'driver': 'John Driver',
                'seat_3': 'Alice Smith',
                'seat_7': 'Bob Johnson',
                'seat_19': 'Carol Davis',
                'seat_24': 'Mike Wilson',
              },
              seatMetadata: const {
                'seat_3': {
                  'booking_id': 'BK001',
                  'price': 50.0,
                  'meal_preference': 'Vegetarian'
                },
                'seat_7': {
                  'booking_id': 'BK002',
                  'price': 45.0,
                  'special_needs': 'Window seat'
                },
                'seat_15': {
                  'reason': 'Under maintenance',
                  'estimated_fix': '2024-08-10'
                },
                'seat_19': {
                  'booking_id': 'BK003',
                  'price': 55.0,
                  'loyalty_member': true
                },
              },
            ),

            // show selected seats summary
            if (showSelectionSummary && selectedSeats.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 10, right: 10, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Selected Seats',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: selectedSeats.map((seat) {
                          return Chip(
                            label: Text(seat.seatNumber),

                            // backgroundColor: Colors.blue.shade100,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
