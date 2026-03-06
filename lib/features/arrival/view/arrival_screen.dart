import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_stop/features/arrival/controller/arrival_controller.dart';
import 'package:next_stop/features/arrival/models/location_point_model.dart';
import 'package:next_stop/features/arrival/models/location_point_type_enum.dart';
import 'package:next_stop/features/arrival/models/trip_model.dart';
import 'package:next_stop/features/arrival/widgets/tracking_bar_widget.dart';

class ArrivalScreen extends ConsumerStatefulWidget {
  const ArrivalScreen({super.key});

  @override
  ConsumerState<ArrivalScreen> createState() => _ArrivalScreenState();
}

class _ArrivalScreenState extends ConsumerState<ArrivalScreen> {
  bool showLocationDetails = false;

  LocationPoint? origin;
  LocationPoint? destination;

  void toggleLocationDetails() {
    setState(() {
      showLocationDetails = !showLocationDetails;
    });
  }

  Future<LocationPoint?> _pickPoint(
    BuildContext context,
    LocationPointType type,
  ) async {
    final latController = TextEditingController();
    final lngController = TextEditingController();
    final nameController = TextEditingController();

    return showModalBottomSheet<LocationPoint>(
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
                type == LocationPointType.origin
                    ? "Set Origin"
                    : "Set Destination",
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
                    LocationPoint(
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
    final position = ref.watch(arrivalProvider);
    final controller = ref.read(arrivalProvider.notifier);

    final isTracking = position != null;
    final activeTrip = controller.activeTrip;

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

            if (activeTrip == null) ...[
              Card(
                child: ListTile(
                  title: Text(origin?.displayName ?? "Set Origin"),
                  leading: const Icon(Icons.my_location),
                  onTap: () async {
                    final point = await _pickPoint(
                      context,
                      LocationPointType.origin,
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
                      LocationPointType.destination,
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
                                name:
                                    "Trip ${controller.savedTrips.length + 1}",
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
            ] else ...[
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
                      controller.distance == null
                          ? "--"
                          : "${(controller.distance! / 1000).toStringAsFixed(2)} km",
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

            Expanded(
              child: ListView.builder(
                itemCount: controller.savedTrips.length,
                itemBuilder: (context, index) {
                  final trip = controller.savedTrips[index];

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
