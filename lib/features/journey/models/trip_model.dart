import 'package:next_stop/features/journey/models/waypoint_model.dart';

class Trip {
  final String id;
  final String name;
  final Waypoint? origin;
  final Waypoint? destination;
  final double alertRadius;

  const Trip({
    required this.id,
    required this.name,
    this.origin,
    this.destination,
    this.alertRadius = 500,
  });

  Trip copyWith({
    String? id,
    String? name,
    Waypoint? origin,
    Waypoint? destination,
    double? alertRadius,
  }) {
    return Trip(
      id: id ?? this.id,
      name: name ?? this.name,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      alertRadius: alertRadius ?? this.alertRadius,
    );
  }

  @override
  String toString() {
    return '''
Trip(
  id: $id,
  name: $name,
  origin: ${origin != null ? origin.toString() : 'null'},
  destination: ${destination != null ? destination.toString() : 'null'},
  alertRadius: $alertRadius
)
''';
  }
}
