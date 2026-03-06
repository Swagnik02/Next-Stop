import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ActiveTripCard extends StatelessWidget {
  final double? distance;
  final Position? position;
  final VoidCallback onStop;

  const ActiveTripCard({
    super.key,
    required this.distance,
    required this.position,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                    : "${(distance! / 1000).toStringAsFixed(2)} km",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                position == null
                    ? "--"
                    : "${position!.speed.toStringAsFixed(1)} m/s",
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        ElevatedButton(onPressed: onStop, child: const Text("Stop Trip")),
      ],
    );
  }
}
