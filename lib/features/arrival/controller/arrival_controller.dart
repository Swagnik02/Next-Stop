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
          },
        );
  }

  void stopTracking() async {
    await _positionStream?.cancel();
    _positionStream = null;
    state = null;
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }
}
