import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';
import 'package:geolocator/geolocator.dart';

final arrivalProvider = StateNotifierProvider<ArrivalController, Position?>((
  ref,
) {
  return ArrivalController();
});

class ArrivalController extends StateNotifier<Position?> {
  ArrivalController() : super(null);

  StreamSubscription<Position>? _positionStream;

  void startTracking() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5, // update every 5 meters
    );

    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position position) {
            state = position;
          },
        );
  }

  void stopTracking() {
    _positionStream?.cancel();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }
}
