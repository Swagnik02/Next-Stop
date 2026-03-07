import 'package:flutter/material.dart';
import 'package:next_stop/core/widgets/action_card.dart';
import 'package:next_stop/features/journey/models/waypoint_model.dart';

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
        ActionCard(
          leading: const Icon(Icons.trip_origin),
          title: Text(origin?.displayName ?? "Set Origin"),
          onTap: onOriginTap,
        ),

        ActionCard(
          leading: const Icon(Icons.place),
          title: Text(destination?.displayName ?? "Set Destination"),
          onTap: onDestinationTap,
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
