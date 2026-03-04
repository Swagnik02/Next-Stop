import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_stop/features/arrival/controller/arrival_controller.dart';

class ArrivalScreen extends ConsumerWidget {
  const ArrivalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTracking = ref.watch(arrivalProvider);
    final controller = ref.read(arrivalProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("Next Stop")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isTracking ? "Tracking Started" : "Tracking Stopped",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (isTracking) {
                  controller.stopTracking();
                } else {
                  controller.startTracking();
                }
              },
              child: Text(isTracking ? "Stop" : "Start"),
            ),
          ],
        ),
      ),
    );
  }
}
