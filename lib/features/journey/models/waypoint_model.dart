import 'package:next_stop/features/journey/models/waypoint_type_enum.dart';

class Waypoint {
  final double latitude;
  final double longitude;
  final String? name;
  final WaypointType type;

  const Waypoint({
    required this.latitude,
    required this.longitude,
    required this.type,
    this.name,
  });

  String get displayName {
    if (name != null && name!.isNotEmpty) {
      return name!;
    }

    return type == WaypointType.origin ? "Origin" : "Destination";
  }
}
