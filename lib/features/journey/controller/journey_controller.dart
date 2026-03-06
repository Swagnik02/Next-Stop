import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';
import 'package:geolocator/geolocator.dart';
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
          ],
        ),
      );

  StreamSubscription<Position>? _positionStream;

  /// FETCH CURRENT LOCATION ONCE
  Future<void> fetchCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    state = state.copyWith(currentPosition: position);
  }

  /// START GPS TRACKING
  void startTracking() async {
    await _positionStream?.cancel();

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 3,
    );

    _positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(_onLocationUpdate);
  }

  void _onLocationUpdate(Position position) {
    double? distance;

    if (state.trip?.destination != null) {
      distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        state.trip!.destination!.latitude,
        state.trip!.destination!.longitude,
      );
    }

    final origin = Waypoint(
      latitude: position.latitude,
      longitude: position.longitude,
      type: WaypointType.origin,
      name: "Current Location",
    );

    state = state.copyWith(
      tracking: true,
      currentPosition: position,
      distance: distance,
      trip: state.trip?.copyWith(origin: origin),
    );
  }

  /// STOP GPS
  void stopTracking() async {
    await _positionStream?.cancel();
    _positionStream = null;

    state = state.copyWith(
      tracking: false,
      currentPosition: null,
      clearDistance: true,
    );
  }

  /// SAVE trip
  void saveTrip(Trip trip) {
    final updated = [...state.savedTrips, trip];
    state = state.copyWith(savedTrips: updated);
  }

  /// START trip
  void startTrip(Trip trip) {
    state = state.copyWith(trip: trip);
    startTracking();
  }

  /// STOP trip
  void stopTrip() {
    stopTracking();

    state = state.copyWith(clearTrip: true, clearDistance: true);
  }

  void clearTrips() {
    state = state.copyWith(savedTrips: []);
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }
}
