import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:next_stop/features/journey/controller/journey_controller.dart';

Card trackingBar(
  bool showLocationDetails,
  bool isTracking,
  JourneyController controller,
  Position? position,
  VoidCallback toggleLocationDetails,
) {
  return Card(
    elevation: 2,
    child: Column(
      children: [
        ListTile(
          leading: Icon(
            isTracking ? Icons.gps_fixed : Icons.gps_off,
            color: isTracking ? Colors.teal : Colors.grey,
          ),

          title: Text(
            isTracking ? "Tracking Active" : "Tracking Stopped",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),

          subtitle: const Text("Live GPS location"),

          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Start / Stop tracking
              IconButton(
                icon: Icon(isTracking ? Icons.stop : Icons.play_arrow),
                onPressed: () {
                  if (isTracking) {
                    controller.stopTracking();
                  } else {
                    controller.startTracking();
                  }
                },
              ),

              /// Expand / Collapse
              IconButton(
                icon: Icon(
                  showLocationDetails
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                ),
                onPressed: toggleLocationDetails,
              ),
            ],
          ),
        ),

        if (showLocationDetails && position != null)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  "Current Location",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                _infoTile(
                  icon: Icons.my_location,
                  title: "Latitude",
                  value: position.latitude.toString(),
                ),

                _infoTile(
                  icon: Icons.place,
                  title: "Longitude",
                  value: position.longitude.toString(),
                ),

                _infoTile(
                  icon: Icons.speed,
                  title: "Speed",
                  value: "${position.speed.toStringAsFixed(2)} m/s",
                ),

                _infoTile(
                  icon: Icons.gps_fixed,
                  title: "Accuracy",
                  value: "${position.accuracy.toStringAsFixed(2)} m",
                ),

                _infoTile(
                  icon: Icons.terrain,
                  title: "Altitude",
                  value: "${position.altitude.toStringAsFixed(2)} m",
                ),

                _infoTile(
                  icon: Icons.explore,
                  title: "Heading",
                  value: position.heading.toStringAsFixed(2),
                ),
              ],
            ),
          ),

        if (showLocationDetails && position == null)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text("Location not available yet"),
          ),
      ],
    ),
  );
}

Widget _infoTile({
  required IconData icon,
  required String title,
  required String value,
}) {
  return ListTile(
    leading: Icon(icon),
    title: Text(title),
    trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
  );
}
