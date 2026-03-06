import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';
import 'package:geolocator/geolocator.dart';
import '../models/arrival_state.dart';
import '../models/location_point_model.dart';
import '../models/location_point_type_enum.dart';
import '../models/trip_model.dart';

final arrivalProvider = StateNotifierProvider<ArrivalController, ArrivalState>(
  (ref) => ArrivalController(),
);

class ArrivalController extends StateNotifier<ArrivalState> {
  ArrivalController()
    : super(
        ArrivalState(
          tracking: false,
          savedTrips: [
            Trip(
              id: "test1",
              name: "test1",
              origin: LocationPoint(
                latitude: 12.8431656,
                longitude: 77.635666,
                name: "PG",
                type: LocationPointType.origin,
              ),
              destination: LocationPoint(
                latitude: 12.8401781,
                longitude: 77.6482086,
                name: "Barbeque Nation",
                type: LocationPointType.destination,
              ),
            ),
          ],
        ),
      );

  StreamSubscription<Position>? _positionStream;

  /// START GPS
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

    final origin = LocationPoint(
      latitude: position.latitude,
      longitude: position.longitude,
      type: LocationPointType.origin,
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

  /// SAVE TRIP
  void saveTrip(Trip trip) {
    final updatedTrips = [...state.savedTrips, trip];

    state = state.copyWith(savedTrips: updatedTrips);
  }

  /// START TRIP
  void startTrip(Trip trip) {
    state = state.copyWith(trip: trip);
    startTracking();
  }

  /// STOP TRIP
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
