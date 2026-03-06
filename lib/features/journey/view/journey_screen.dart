import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_stop/features/journey/controller/journey_controller.dart';
import 'package:next_stop/features/journey/models/waypoint_model.dart';
import 'package:next_stop/features/journey/models/waypoint_type_enum.dart';
import 'package:next_stop/features/journey/widgets/tracking_bar_widget.dart';
import 'package:next_stop/features/journey/models/trip_model.dart';

class JourneyScreen extends ConsumerStatefulWidget {
  const JourneyScreen({super.key});

  @override
  ConsumerState<JourneyScreen> createState() => JourneyScreenState();
}

class JourneyScreenState extends ConsumerState<JourneyScreen> {
  bool showLocationDetails = false;

  Waypoint? origin;
  Waypoint? destination;

  void toggleLocationDetails() {
    setState(() {
      showLocationDetails = !showLocationDetails;
    });
  }

  Future<Waypoint?> _pickPoint(BuildContext context, WaypointType type) async {
    final latController = TextEditingController();
    final lngController = TextEditingController();
    final nameController = TextEditingController();

    return showModalBottomSheet<Waypoint>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                type == WaypointType.origin ? "Set Origin" : "Set Destination",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: latController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Latitude"),
              ),

              TextField(
                controller: lngController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Longitude"),
              ),

              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                child: const Text("Save"),
                onPressed: () {
                  final lat = double.tryParse(latController.text);
                  final lng = double.tryParse(lngController.text);

                  if (lat == null || lng == null) return;

                  Navigator.pop(
                    context,
                    Waypoint(
                      latitude: lat,
                      longitude: lng,
                      type: type,
                      name: nameController.text,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(journeyProvider);
    final controller = ref.read(journeyProvider.notifier);

    final position = state.currentPosition;
    final activeTrip = state.trip;
    final distance = state.distance;
    final savedTrips = state.savedTrips;

    final isTracking = position != null;

    return Scaffold(
      appBar: AppBar(title: const Text("Next Stop"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            trackingBar(
              showLocationDetails,
              isTracking,
              controller,
              position,
              toggleLocationDetails,
            ),

            const SizedBox(height: 20),

            /// CREATE Trip UI
            if (activeTrip == null) ...[
              Card(
                child: ListTile(
                  title: Text(origin?.displayName ?? "Set Origin"),
                  leading: const Icon(Icons.my_location),
                  onTap: () async {
                    final point = await _pickPoint(
                      context,
                      WaypointType.origin,
                    );
                    if (point != null) {
                      setState(() => origin = point);
                    }
                  },
                ),
              ),

              Card(
                child: ListTile(
                  title: Text(destination?.displayName ?? "Set Destination"),
                  leading: const Icon(Icons.place),
                  onTap: () async {
                    final point = await _pickPoint(
                      context,
                      WaypointType.destination,
                    );
                    if (point != null) {
                      setState(() => destination = point);
                    }
                  },
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      child: const Text("Save Trip"),
                      onPressed: origin != null && destination != null
                          ? () {
                              final trip = Trip(
                                id: DateTime.now().millisecondsSinceEpoch
                                    .toString(),
                                name: "Trip ${savedTrips.length + 1}",
                                origin: origin,
                                destination: destination,
                              );

                              controller.saveTrip(trip);
                            }
                          : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      child: const Text("Start Trip"),
                      onPressed: origin != null && destination != null
                          ? () {
                              controller.startTrip(
                                Trip(
                                  id: "active",
                                  name: "Active Trip",
                                  origin: origin,
                                  destination: destination,
                                ),
                              );
                            }
                          : null,
                    ),
                  ),
                ],
              ),
            ]
            /// ACTIVE Trip UI
            else ...[
              Container(
                height: 220,
                width: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 6, color: Colors.teal),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      distance == null
                          ? "--"
                          : "${(distance / 1000).toStringAsFixed(2)} km",
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      position == null
                          ? "--"
                          : "${position.speed.toStringAsFixed(1)} m/s",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: controller.stopTrip,
                child: const Text("Stop Trip"),
              ),
            ],

            const SizedBox(height: 20),

            /// SAVED TripS LIST
            Expanded(
              child: ListView.builder(
                itemCount: savedTrips.length,
                itemBuilder: (context, index) {
                  final trip = savedTrips[index];

                  return Card(
                    child: ListTile(
                      title: Text(trip.name),
                      subtitle: Text(
                        "${trip.origin?.displayName} → ${trip.destination?.displayName}",
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.play_arrow),
                        onPressed: () {
                          controller.startTrip(trip);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
