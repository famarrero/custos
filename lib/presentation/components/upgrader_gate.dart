import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

class UpgradeGate extends StatefulWidget {
  final Widget child;

  const UpgradeGate({
    super.key,
    required this.child,
  });

  @override
  State<UpgradeGate> createState() => _UpgradeGateState();
}

class _UpgradeGateState extends State<UpgradeGate> {
  late final Upgrader _upgrader;

  @override
  void initState() {
    super.initState();

    _upgrader = Upgrader(
      // minAppVersion: '1.0.0',
      durationUntilAlertAgain: const Duration(days: 1),
      debugLogging: true,
      willDisplayUpgrade: ({
        required bool display,
        String? installedVersion,
        UpgraderVersionInfo? versionInfo,
      }) {
        debugPrint('--- Upgrade Debug ---');
        debugPrint('Display: $display');
        debugPrint('Installed: $installedVersion');
        debugPrint('Store: ${versionInfo?.appStoreVersion}');
        // debugPrint('Min required: ${widget.minRequiredVersion}');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      upgrader: _upgrader,
      child: widget.child,
    );
  }
}
