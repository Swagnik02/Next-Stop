import 'package:flutter/material.dart';
import '../models/trip_model.dart';

class SavedTripsList extends StatelessWidget {
  final List<Trip> trips;
  final Function(Trip) onStart;

  const SavedTripsList({super.key, required this.trips, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: trips.length,
        itemBuilder: (context, index) {
          final trip = trips[index];

          return Card(
            child: ListTile(
              title: Text(trip.name),
              subtitle: Text(
                "${trip.origin?.displayName} → ${trip.destination?.displayName}",
              ),
              trailing: IconButton(
                icon: const Icon(Icons.play_arrow),
                onPressed: () => onStart(trip),
              ),
            ),
          );
        },
      ),
    );
  }
}
