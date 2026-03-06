import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_stop/features/arrival/view/arrival_screen.dart';
import 'package:next_stop/features/permissions/controller/permission_controller.dart';

class PermissionScreen extends ConsumerWidget {
  const PermissionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(permissionProvider);
    final controller = ref.read(permissionProvider.notifier);

    Widget permissionTile(String title, bool granted, VoidCallback onTap) {
      return Card(
        child: ListTile(
          title: Text(title),
          trailing: Icon(
            granted ? Icons.check_circle : Icons.radio_button_unchecked,
            color: granted ? Colors.green : Colors.grey,
          ),
          onTap: onTap,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Permissions Required")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Next Stop needs the following permissions "
              "to wake you before your destination.",
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            permissionTile(
              "Enable GPS",
              state.gpsEnabled,
              controller.enableGps,
            ),

            permissionTile(
              "Allow Location Access",
              state.locationGranted,
              controller.requestLocation,
            ),

            permissionTile(
              "Allow Background Location",
              state.backgroundGranted,
              controller.requestBackgroundLocation,
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: state.allGranted
                    ? () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ArrivalScreen(),
                          ),
                        );
                      }
                    : null,
                child: const Text("Continue"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
