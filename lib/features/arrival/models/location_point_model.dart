import 'package:next_stop/features/arrival/models/location_point_type_enum.dart';

class LocationPoint {
  final double latitude;
  final double longitude;
  final String? name;
  final LocationPointType type;

  const LocationPoint({
    required this.latitude,
    required this.longitude,
    required this.type,
    this.name,
  });

  String get displayName {
    if (name != null && name!.isNotEmpty) {
      return name!;
    }

    return type == LocationPointType.origin ? "Origin" : "Destination";
  }
}
