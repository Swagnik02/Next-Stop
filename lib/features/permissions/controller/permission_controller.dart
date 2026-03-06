import 'package:flutter_riverpod/legacy.dart';
import 'package:next_stop/features/permissions/service/permission_service.dart';

class PermissionState {
  final bool gpsEnabled;
  final bool locationGranted;
  final bool backgroundGranted;

  const PermissionState({
    required this.gpsEnabled,
    required this.locationGranted,
    required this.backgroundGranted,
  });

  bool get allGranted => gpsEnabled && locationGranted && backgroundGranted;

  PermissionState copyWith({
    bool? gpsEnabled,
    bool? locationGranted,
    bool? backgroundGranted,
  }) {
    return PermissionState(
      gpsEnabled: gpsEnabled ?? this.gpsEnabled,
      locationGranted: locationGranted ?? this.locationGranted,
      backgroundGranted: backgroundGranted ?? this.backgroundGranted,
    );
  }
}

final permissionProvider =
    StateNotifierProvider<PermissionController, PermissionState>((ref) {
      return PermissionController();
    });

class PermissionController extends StateNotifier<PermissionState> {
  PermissionController()
    : super(
        const PermissionState(
          gpsEnabled: false,
          locationGranted: false,
          backgroundGranted: false,
        ),
      );

  Future<void> checkPermissions() async {
    final gps = await PermissionService.isGpsEnabled();
    final location = await PermissionService.isLocationGranted();
    final background = await PermissionService.isBackgroundLocationGranted();

    state = state.copyWith(
      gpsEnabled: gps,
      locationGranted: location,
      backgroundGranted: background,
    );
  }

  Future<void> enableGps() async {
    await PermissionService.openGpsSettings();
    await checkPermissions();
  }

  Future<void> requestLocation() async {
    await PermissionService.requestLocation();
    await checkPermissions();
  }

  Future<void> requestBackgroundLocation() async {
    await PermissionService.requestBackgroundLocation();
    await checkPermissions();
  }
}
