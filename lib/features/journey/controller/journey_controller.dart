import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';
import 'package:next_stop/core/models/location_data.dart';
import 'package:next_stop/core/services/location_service.dart';
import 'package:next_stop/features/journey/controller/journey_state.dart';
import 'package:next_stop/features/journey/models/trip_model.dart';
import 'package:next_stop/features/journey/models/waypoint_model.dart';
import 'package:next_stop/features/journey/models/waypoint_type_enum.dart';

final journeyProvider = StateNotifierProvider<JourneyController, JourneyState>(
  (ref) => JourneyController(),
);

class JourneyController extends StateNotifier<JourneyState> {
  JourneyController()
    : super(
        JourneyState(
          tracking: false,
          savedTrips: [
            Trip(
              id: "test1",
              name: "test1",
              origin: Waypoint(
                latitude: 12.8431656,
                longitude: 77.635666,
                name: "PG",
                type: WaypointType.origin,
              ),
              destination: Waypoint(
                latitude: 12.8401781,
                longitude: 77.6482086,
                name: "Barbeque Nation",
                type: WaypointType.destination,
              ),
            ),
            Trip(
              id: "test2",
              name: "DTDC",
              origin: Waypoint(
                latitude: 12.8431656,
                longitude: 77.635666,
                name: "PG",
                type: WaypointType.origin,
              ),
              destination: Waypoint(
                latitude: 12.8405525,
                longitude: 77.6493959,
                name: "DTDC",
                type: WaypointType.destination,
              ),
            ),
          ],
        ),
      );

  final LocationService _locationService = LocationService();

  StreamSubscription<LocationData>? _locationStream;

  /// FETCH CURRENT LOCATION
  Future<void> fetchCurrentLocation() async {
    final location = await _locationService.getCurrentLocation();

    state = state.copyWith(currentLocation: location);
  }

  void loadTripIntoBuilder(Trip trip) {
    state = state.copyWith(trip: null);
  }

  /// START TRACKING
  void startTracking() async {
    await _locationStream?.cancel();

    _locationStream = _locationService.getLocationStream().listen(
      _onLocationUpdate,
    );
  }

  void _onLocationUpdate(LocationData location) {
    double? distance;

    if (state.trip?.destination != null) {
      distance = _locationService.calculateDistance(
        location.latitude,
        location.longitude,
        state.trip!.destination!.latitude,
        state.trip!.destination!.longitude,
      );
    }

    final origin = Waypoint(
      latitude: location.latitude,
      longitude: location.longitude,
      type: WaypointType.origin,
      name: "Current Location",
    );

    state = state.copyWith(
      tracking: true,
      currentLocation: location,
      distance: distance,
      trip: state.trip?.copyWith(origin: origin),
    );
  }

  void stopTracking() async {
    await _locationStream?.cancel();
    _locationStream = null;

    state = state.copyWith(
      tracking: false,
      currentLocation: null,
      clearDistance: true,
    );
  }

  void saveTrip(Trip trip) {
    final updated = [...state.savedTrips, trip];
    state = state.copyWith(savedTrips: updated);
  }

  void startTrip(Trip trip) {
    state = state.copyWith(trip: trip);
    startTracking();
  }

  void stopTrip() {
    stopTracking();

    state = state.copyWith(trip: null, clearTrip: true, clearDistance: true);
  }

  void clearTrips() {
    state = state.copyWith(savedTrips: []);
  }

  @override
  void dispose() {
    _locationStream?.cancel();
    super.dispose();
  }
}
