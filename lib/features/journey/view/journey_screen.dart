import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_stop/features/journey/controller/journey_controller.dart';
import 'package:next_stop/features/journey/models/trip_model.dart';
import 'package:next_stop/features/journey/models/waypoint_model.dart';
import 'package:next_stop/features/journey/models/waypoint_type_enum.dart';
import 'package:next_stop/features/journey/utils/waypoint_picker.dart';
import 'package:next_stop/features/journey/widgets/active_trip_card.dart';
import 'package:next_stop/features/journey/widgets/saved_trips_list.dart';
import 'package:next_stop/features/journey/widgets/test_maps_parser.dart';
import 'package:next_stop/features/journey/widgets/trip_builder_card.dart';

class JourneyScreen extends ConsumerStatefulWidget {
  const JourneyScreen({super.key});

  @override
  ConsumerState<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends ConsumerState<JourneyScreen> {
  bool showLocationDetails = false;

  Waypoint? origin;
  Waypoint? destination;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(journeyProvider.notifier).fetchCurrentLocation();
    });
  }

  void toggleLocationDetails() {
    setState(() {
      showLocationDetails = !showLocationDetails;
    });
  }

  Trip buildTrip(String name) {
    return Trip(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      origin: origin!,
      destination: destination!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(journeyProvider);
    final controller = ref.read(journeyProvider.notifier);

    final currentLocation = state.currentLocation;
    final activeTrip = state.trip;
    final distance = state.distance;
    final savedTrips = state.savedTrips;

    // final isTracking = currentLocation != null;

    return Scaffold(
      appBar: AppBar(title: const Text("Next Stop"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TestMapsParser(),
            // trackingBar(
            //   showLocationDetails,
            //   isTracking,
            //   controller,
            //   currentLocation,
            //   toggleLocationDetails,
            // ),
            const SizedBox(height: 20),

            /// LOCATION STATUS
            if (currentLocation == null)
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "📍 Finding your current location...\nSetting things up before your journey begins.",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

            /// TRIP BUILDER OR ACTIVE TRIP
            activeTrip == null
                ? TripBuilderCard(
                    origin: origin,
                    destination: destination,
                    onOriginTap: () async {
                      final point = await showWaypointPicker(
                        context,
                        WaypointType.origin,
                        currentLocation,
                        origin,
                      );
                      if (point != null) setState(() => origin = point);
                    },
                    onDestinationTap: () async {
                      final point = await showWaypointPicker(
                        context,
                        WaypointType.destination,
                        currentLocation,
                        destination,
                      );
                      if (point != null) setState(() => destination = point);
                    },
                    onSave: origin != null && destination != null
                        ? () => controller.saveTrip(
                            buildTrip("Trip ${savedTrips.length + 1}"),
                          )
                        : null,
                    onStart: origin != null && destination != null
                        ? () => controller.startTrip(buildTrip("Active Trip"))
                        : null,
                  )
                : ActiveTripCard(
                    distance: distance,
                    location: currentLocation,
                    onStop: controller.stopTrip,
                  ),

            const SizedBox(height: 20),

            /// SAVED TRIPS ALWAYS AVAILABLE
            SavedTripsList(
              trips: savedTrips,
              onStart: controller.startTrip,
              onSelect: (trip) {
                setState(() {
                  origin = trip.origin;
                  destination = trip.destination;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
