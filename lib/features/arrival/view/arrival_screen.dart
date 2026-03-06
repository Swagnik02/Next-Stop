import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_stop/features/arrival/controller/arrival_controller.dart';
import 'package:next_stop/features/arrival/widgets/tracking_bar_widget.dart';

class ArrivalScreen extends ConsumerStatefulWidget {
  const ArrivalScreen({super.key});

  @override
  ConsumerState<ArrivalScreen> createState() => _ArrivalScreenState();
}

class _ArrivalScreenState extends ConsumerState<ArrivalScreen> {
  bool showLocationDetails = false;

  void toggleLocationDetails() {
    setState(() {
      showLocationDetails = !showLocationDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    final position = ref.watch(arrivalProvider);
    final controller = ref.read(arrivalProvider.notifier);

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
              toggleLocationDetails, // 👈 pass callback
            ),

            const Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
