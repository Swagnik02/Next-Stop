import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class PermissionService {
  /// Check if GPS is enabled
  static Future<bool> isGpsEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Open GPS settingss
  static Future<void> openGpsSettings() async {
    await Geolocator.openLocationSettings();
  }

  /// Check location permission
  static Future<bool> isLocationGranted() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }

  /// Request location permission
  static Future<bool> requestLocation() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  /// Check background location permission
  static Future<bool> isBackgroundLocationGranted() async {
    final status = await Permission.locationAlways.status;
    return status.isGranted;
  }

  /// Request background location permission
  static Future<bool> requestBackgroundLocation() async {
    final status = await Permission.locationAlways.request();
    return status.isGranted;
  }

  /// Check notification permission (Android 13+)
  static Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }
}
