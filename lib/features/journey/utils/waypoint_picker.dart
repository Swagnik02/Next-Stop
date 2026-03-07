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

  return showDialog<Waypoint>(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// TITLE
                Row(
                  children: [
                    Icon(
                      type == WaypointType.origin
                          ? Icons.trip_origin
                          : Icons.flag,
                      color: Colors.teal,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      type == WaypointType.origin
                          ? "Set Origin"
                          : "Set Destination",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// GPS BUTTON
                if (currentLocation != null)
                  OutlinedButton.icon(
                    icon: const Icon(Icons.gps_fixed),
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

                /// LATITUDE
                TextField(
                  controller: latController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Latitude",
                    prefixIcon: Icon(Icons.north),
                  ),
                ),

                const SizedBox(height: 12),

                /// LONGITUDE
                TextField(
                  controller: lngController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Longitude",
                    prefixIcon: Icon(Icons.east),
                  ),
                ),

                const SizedBox(height: 12),

                /// NAME
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Location Name",
                    prefixIcon: Icon(Icons.location_on),
                  ),
                ),

                const SizedBox(height: 25),

                /// ACTION BUTTONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 10),
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
              ],
            ),
          ),
        ),
      );
    },
  );
}
