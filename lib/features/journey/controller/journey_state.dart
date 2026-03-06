import 'package:geolocator/geolocator.dart';
import 'package:next_stop/features/journey/models/trip_model.dart';

class JourneyState {
  final bool tracking;
  final Position? currentPosition;
  final Trip? trip;
  final double? distance;
  final List<Trip> savedTrips;

  const JourneyState({
    required this.tracking,
    this.currentPosition,
    this.trip,
    this.distance,
    this.savedTrips = const [],
  });

  JourneyState copyWith({
    bool? tracking,
    Position? currentPosition,
    Trip? trip,
    double? distance,
    List<Trip>? savedTrips,
    bool clearTrip = false,
    bool clearDistance = false,
  }) {
    return JourneyState(
      tracking: tracking ?? this.tracking,
      currentPosition: currentPosition ?? this.currentPosition,
      trip: clearTrip ? null : (trip ?? this.trip),
      distance: clearDistance ? null : (distance ?? this.distance),
      savedTrips: savedTrips ?? this.savedTrips,
    );
  }
}
