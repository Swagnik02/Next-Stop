import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:next_stop/features/arrival/view/arrival_screen.dart';
import 'package:next_stop/features/permissions/view/permission_screen.dart';
import 'package:next_stop/features/permissions/controller/permission_controller.dart';

class RootScreen extends ConsumerStatefulWidget {
  const RootScreen({super.key});

  @override
  ConsumerState<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends ConsumerState<RootScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(permissionProvider.notifier).checkPermissions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final permissionState = ref.watch(permissionProvider);

    if (permissionState.allGranted) {
      return const ArrivalScreen();
    }

    return const PermissionScreen();
  }
}
