import 'package:geolocator/geolocator.dart';
import 'trip_model.dart';

class ArrivalState {
  final bool tracking;
  final Position? currentPosition;
  final Trip? trip;
  final double? distance;

  const ArrivalState({
    required this.tracking,
    this.currentPosition,
    this.trip,
    this.distance,
  });

  ArrivalState copyWith({
    bool? tracking,
    Position? currentPosition,
    Trip? trip,
    double? distance,
  }) {
    return ArrivalState(
      tracking: tracking ?? this.tracking,
      currentPosition: currentPosition ?? this.currentPosition,
      trip: trip ?? this.trip,
      distance: distance ?? this.distance,
    );
  }
}
