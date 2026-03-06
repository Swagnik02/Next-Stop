import 'package:geolocator/geolocator.dart';
import '../models/location_data.dart';

class LocationService {
  /// Get current location once
  Future<LocationData> getCurrentLocation() async {
    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return LocationData(
      latitude: pos.latitude,
      longitude: pos.longitude,
      speed: pos.speed,
      accuracy: pos.accuracy,
      altitude: pos.altitude,
      heading: pos.heading,
    );
  }

  /// Stream for live tracking
  Stream<LocationData> getLocationStream() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 3,
    );

    return Geolocator.getPositionStream(locationSettings: locationSettings).map(
      (pos) {
        return LocationData(
          latitude: pos.latitude,
          longitude: pos.longitude,
          speed: pos.speed,
          accuracy: pos.accuracy,
          altitude: pos.altitude,
          heading: pos.heading,
        );
      },
    );
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }
}
