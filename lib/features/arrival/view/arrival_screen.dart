import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_stop/features/arrival/controller/arrival_controller.dart';

class ArrivalScreen extends ConsumerWidget {
  const ArrivalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final position = ref.watch(arrivalProvider);
    final controller = ref.read(arrivalProvider.notifier);

    final isTracking = position != null;

    return Scaffold(
      appBar: AppBar(title: const Text("Next Stop"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// Tracking status card
            Card(
              elevation: 2,
              child: ListTile(
                leading: Icon(
                  isTracking ? Icons.gps_fixed : Icons.gps_off,
                  color: isTracking ? Colors.teal : Colors.grey,
                ),
                title: Text(
                  isTracking ? "Tracking Active" : "Tracking Stopped",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text("Live GPS location"),
              ),
            ),

            const SizedBox(height: 20),

            /// Location information
            if (position != null)
              Expanded(
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          "Current Location",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
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
                ),
              ),

            if (position == null)
              const Expanded(
                child: Center(
                  child: Text(
                    "Press Start Tracking to get your live location.",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

            const SizedBox(height: 20),

            /// Start / Stop button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: Icon(isTracking ? Icons.stop : Icons.play_arrow),
                label: Text(isTracking ? "Stop Tracking" : "Start Tracking"),
                onPressed: () {
                  if (isTracking) {
                    controller.stopTracking();
                  } else {
                    controller.startTracking();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _infoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
