import 'dart:async';
import 'package:flutter_riverpod/legacy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:next_stop/features/arrival/models/location_point_model.dart';
import 'package:next_stop/features/arrival/models/location_point_type_enum.dart';
import 'package:next_stop/features/arrival/models/trip_model.dart';

final arrivalProvider = StateNotifierProvider<ArrivalController, Position?>(
  (ref) => ArrivalController(),
);

class ArrivalController extends StateNotifier<Position?> {
  ArrivalController() : super(null);

  StreamSubscription<Position>? _positionStream;

  List<Trip> savedTrips = [
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
  ];

  Trip? activeTrip;

  double? distance;

  void _notify() {
    state = state;
  }

  void startTracking() async {
    await _positionStream?.cancel();

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 3,
    );
    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position position) {
            state = position;

            if (activeTrip?.destination != null) {
              distance = Geolocator.distanceBetween(
                position.latitude,
                position.longitude,
                activeTrip!.destination!.latitude,
                activeTrip!.destination!.longitude,
              );
            }

            if (activeTrip != null) {
              final origin = LocationPoint(
                latitude: position.latitude,
                longitude: position.longitude,
                type: LocationPointType.origin,
                name: "Current Location",
              );

              activeTrip = activeTrip!.copyWith(origin: origin);
            }

            _notify(); // important
          },
        );
  }

  void stopTracking() async {
    await _positionStream?.cancel();
    _positionStream = null;
    state = null;
  }

  void saveTrip(Trip trip) {
    savedTrips.add(trip);
    _notify();
  }

  void startTrip(Trip trip) {
    activeTrip = trip;
    startTracking();
    _notify();
  }

  void stopTrip() {
    activeTrip = null;
    distance = null;
    _notify();
  }

  void clearTrips() {
    savedTrips.clear();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }
}
