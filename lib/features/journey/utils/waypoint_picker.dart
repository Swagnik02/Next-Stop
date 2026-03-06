import 'package:flutter/material.dart';
import 'package:next_stop/core/models/location_data.dart';
import 'package:next_stop/features/journey/models/waypoint_model.dart';
import 'package:next_stop/features/journey/models/waypoint_type_enum.dart';

Future<Waypoint?> showWaypointPicker(
  BuildContext context,
  WaypointType type,
  LocationData? currentLocation,
) async {
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
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            /// USE CURRENT LOCATION BUTTON
            if (currentLocation != null)
              ElevatedButton.icon(
                icon: const Icon(Icons.my_location),
                label: const Text("Use Current Location"),
                onPressed: () {
                  latController.text = currentLocation.latitude.toString();
                  lngController.text = currentLocation.longitude.toString();

                  if (nameController.text.isEmpty) {
                    nameController.text = "Current Location";
                  }
                },
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
              child: const Text("Save"),
            ),
          ],
        ),
      );
    },
  );
}
