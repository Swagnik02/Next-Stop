import 'package:geolocator/geolocator.dart';
import 'trip_model.dart';

class ArrivalState {
  final bool tracking;
  final Position? currentPosition;
  final Trip? trip;
  final double? distance;
  final List<Trip> savedTrips;

  const ArrivalState({
    required this.tracking,
    this.currentPosition,
    this.trip,
    this.distance,
    this.savedTrips = const [],
  });

  ArrivalState copyWith({
    bool? tracking,
    Position? currentPosition,
    Trip? trip,
    double? distance,
    List<Trip>? savedTrips,
    bool clearTrip = false,
    bool clearDistance = false,
  }) {
    return ArrivalState(
      tracking: tracking ?? this.tracking,
      currentPosition: currentPosition ?? this.currentPosition,
      trip: clearTrip ? null : (trip ?? this.trip),
      distance: clearDistance ? null : (distance ?? this.distance),
      savedTrips: savedTrips ?? this.savedTrips,
    );
  }
}
