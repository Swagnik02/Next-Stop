import 'package:next_stop/features/journey/models/trip_model.dart';
import 'package:next_stop/features/journey/models/waypoint_model.dart';
import 'package:next_stop/features/journey/models/waypoint_type_enum.dart';

Trip extractTripFromMapsUrl(String url) {
  Waypoint? origin;
  Waypoint? destination;

  String? extractDestinationName(String url) {
    final match = RegExp(r'/dir/[^/]+/([^/@?]+)').firstMatch(url);

    if (match == null) return null;

    String raw = match.group(1)!;

    raw = Uri.decodeComponent(raw);

    raw = raw.replaceAll('+', ' ');

    /// Often addresses follow after comma
    return raw.split(',').first.trim();
  }

  final destinationName = extractDestinationName(url);

  /// pattern: /dir/LAT,LNG
  final dirMatch = RegExp(r'/dir/(-?\d+\.\d+),(-?\d+\.\d+)').firstMatch(url);

  if (dirMatch != null) {
    origin = Waypoint(
      latitude: double.parse(dirMatch.group(1)!),
      longitude: double.parse(dirMatch.group(2)!),
      type: WaypointType.origin,
      name: "Shared Origin",
    );
  }

  /// pattern: !2dLNG!3dLAT
  final placeMatch = RegExp(r'!2d(-?\d+\.\d+)!3d(-?\d+\.\d+)').firstMatch(url);

  if (placeMatch != null) {
    destination = Waypoint(
      latitude: double.parse(placeMatch.group(2)!),
      longitude: double.parse(placeMatch.group(1)!),
      type: WaypointType.destination,
      name: destinationName ?? "Shared Destination",
    );
  }

  /// fallback
  if (destination == null) {
    final atMatch = RegExp(r'@(-?\d+\.\d+),(-?\d+\.\d+)').firstMatch(url);

    if (atMatch != null) {
      destination = Waypoint(
        latitude: double.parse(atMatch.group(1)!),
        longitude: double.parse(atMatch.group(2)!),
        type: WaypointType.destination,
        name: destinationName ?? "Shared Destination",
      );
    }
  }

  return Trip(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    name: destinationName ?? "Shared Trip",
    origin: origin,
    destination: destination,
  );
}
