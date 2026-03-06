import 'package:flutter/material.dart';
import '../models/waypoint_model.dart';

class TripBuilderCard extends StatelessWidget {
  final Waypoint? origin;
  final Waypoint? destination;
  final VoidCallback onOriginTap;
  final VoidCallback onDestinationTap;
  final VoidCallback? onSave;
  final VoidCallback? onStart;

  const TripBuilderCard({
    super.key,
    required this.origin,
    required this.destination,
    required this.onOriginTap,
    required this.onDestinationTap,
    required this.onSave,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: ListTile(
            title: Text(origin?.displayName ?? "Set Origin"),
            leading: const Icon(Icons.my_location),
            onTap: onOriginTap,
          ),
        ),

        Card(
          child: ListTile(
            title: Text(destination?.displayName ?? "Set Destination"),
            leading: const Icon(Icons.place),
            onTap: onDestinationTap,
          ),
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: onSave,
                child: const Text("Save Trip"),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: onStart,
                child: const Text("Start Trip"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
