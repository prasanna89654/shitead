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
  int numberOfSeats = 24;
  bool allowMultipleSelection = true;
  bool showLegend = true;
  bool showSelectionSummary = true;
  bool showAisleIndicators = true;
  double seatSize = 50;
  double seatSpacing = 8;
  double aisleWidthFactor = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Customizable Seat Layout'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettingsDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Customization Panel
            Card(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customization Settings',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    _buildCustomizationControls(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Seat Layout with full customization
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
              cardElevation: 3,

              // Legend Customization
              legendTitle: 'Seat Status Guide',
              legendIconSize: 28,
              legendItemSpacing: 20,
              legendRunSpacing: 16,
              showLegendSeatNumbers: true,

              // Bus Layout Customization
              busLayoutTitle: 'Bus Seating Layout',

              // Colors
              legendCardColor: Colors.blue.shade50,
              busLayoutCardColor: Colors.green.shade50,
              aisleIndicatorColor: Colors.grey.shade600,
              aisleBorderColor: Colors.grey.shade400,
              aisleBorderWidth: 2,
              aisleBorderOpacity: 0.5,

              // Text Styles
              legendTitleStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
              busLayoutTitleStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
              legendItemStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.blue.shade700,
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
          ],
        ),
      ),
    );
  }

  Widget _buildCustomizationControls() {
    return Column(
      children: [
        // Number of seats
        Row(
          children: [
            Expanded(
              child: Text('Seats: $numberOfSeats'),
            ),
            Expanded(
              flex: 2,
              child: Slider(
                value: numberOfSeats.toDouble(),
                min: 8,
                max: 40,
                divisions: 32,
                onChanged: (value) {
                  setState(() {
                    numberOfSeats = value.round();
                  });
                },
              ),
            ),
          ],
        ),

        // Seat size
        Row(
          children: [
            Expanded(
              child: Text('Size: ${seatSize.round()}px'),
            ),
            Expanded(
              flex: 2,
              child: Slider(
                value: seatSize,
                min: 30,
                max: 80,
                onChanged: (value) {
                  setState(() {
                    seatSize = value;
                  });
                },
              ),
            ),
          ],
        ),

        // Spacing
        Row(
          children: [
            Expanded(
              child: Text('Spacing: ${seatSpacing.round()}px'),
            ),
            Expanded(
              flex: 2,
              child: Slider(
                value: seatSpacing,
                min: 4,
                max: 20,
                onChanged: (value) {
                  setState(() {
                    seatSpacing = value;
                  });
                },
              ),
            ),
          ],
        ),

        // Aisle width
        Row(
          children: [
            Expanded(
              child: Text('Aisle: ${aisleWidthFactor.toStringAsFixed(1)}x'),
            ),
            Expanded(
              flex: 2,
              child: Slider(
                value: aisleWidthFactor,
                min: 0.5,
                max: 2.0,
                onChanged: (value) {
                  setState(() {
                    aisleWidthFactor = value;
                  });
                },
              ),
            ),
          ],
        ),

        // Toggle switches
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            _buildToggleSwitch('Multiple Selection', allowMultipleSelection,
                (value) {
              setState(() {
                allowMultipleSelection = value;
              });
            }),
            _buildToggleSwitch('Show Legend', showLegend, (value) {
              setState(() {
                showLegend = value;
              });
            }),
            _buildToggleSwitch('Selection Summary', showSelectionSummary,
                (value) {
              setState(() {
                showSelectionSummary = value;
              });
            }),
            _buildToggleSwitch('Aisle Indicators', showAisleIndicators,
                (value) {
              setState(() {
                showAisleIndicators = value;
              });
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildToggleSwitch(
      String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(width: 8),
        Switch(
          value: value,
          onChanged: onChanged,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ],
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Package Features'),
        content: const SingleChildScrollView(
          child: Text(
            'This demo showcases all customizable properties:\n\n'
            '• Visual customization (sizes, spacing, colors)\n'
            '• Layout options (aisle width, indicators)\n'
            '• UI elements (legend, summary, cards)\n'
            '• Text styles and colors\n'
            '• Seat states and metadata\n'
            '• Interactive controls\n\n'
            'Every aspect can be customized through constructor parameters!',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }
}
