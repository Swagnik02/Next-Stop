import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // You can initialize services here later
  // await NotificationService.initialize();
  // await LocationService.initialize();

  runApp(const ProviderScope(child: NextStopApp()));
}
