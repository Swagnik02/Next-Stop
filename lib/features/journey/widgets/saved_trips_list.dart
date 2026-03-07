import 'package:flutter/material.dart';
import 'package:next_stop/core/widgets/action_card.dart';
import '../models/trip_model.dart';

class SavedTripsList extends StatelessWidget {
  final List<Trip> trips;
  final Function(Trip) onStart;
  final Function(Trip) onSelect;

  const SavedTripsList({
    super.key,
    required this.trips,
    required this.onStart,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: trips.length,
        itemBuilder: (context, index) {
          final trip = trips[index];

          return ActionCard(
            title: Text(trip.name),
            subtitle: Text(
              "${trip.origin?.displayName} → ${trip.destination?.displayName}",
            ),
            trailing: IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () => onStart(trip),
            ),
            onTap: () => onSelect(trip),
          );
        },
      ),
    );
  }
}
