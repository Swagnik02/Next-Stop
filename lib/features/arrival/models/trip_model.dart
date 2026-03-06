import 'package:next_stop/features/arrival/models/location_point_model.dart';

class Trip {
  final String id;
  final String name;
  final LocationPoint? origin;
  final LocationPoint? destination;
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
    LocationPoint? origin,
    LocationPoint? destination,
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
}
