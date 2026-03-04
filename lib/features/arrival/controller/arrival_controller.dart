import 'package:flutter_riverpod/legacy.dart';

final arrivalProvider = StateNotifierProvider<ArrivalController, bool>((ref) {
  return ArrivalController();
});

class ArrivalController extends StateNotifier<bool> {
  ArrivalController() : super(false);

  void startTracking() {
    state = true;
  }

  void stopTracking() {
    state = false;
  }
}
