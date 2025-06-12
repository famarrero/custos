import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/device_type.dart';
import 'package:custos/core/utils/failures.dart';
import 'package:custos/presentation/app/l10n/app_localizations.dart';
import 'package:custos/presentation/app/theme/app_theme.dart';
import 'package:custos/presentation/components/failure_widget.dart';
import 'package:custos/presentation/components/scaffold_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:restart_app/restart_app.dart';

/// Main app error widget show when an initialization error occurred.
class CustosErrorApp extends StatefulWidget {
  const CustosErrorApp({super.key, required this.failure});

  final Failure failure;

  @override
  State<CustosErrorApp> createState() => _CustosErrorAppState();
}

class _CustosErrorAppState extends State<CustosErrorApp> {
  @override
  void initState() {
    FlutterNativeSplash.remove();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Ensures that the mouse also serves as a drag device.
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          ...const MaterialScrollBehavior().dragDevices,
        },
      ),
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => context.l10n.custos,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme:
          AppTheme(
            themeMode: ThemeMode.light,
            deviceType: DeviceInfo.getDeviceType(context),
          ).toThemeData(),
      darkTheme:
          AppTheme(
            themeMode: ThemeMode.dark,
            deviceType: DeviceInfo.getDeviceType(context),
          ).toThemeData(),
      themeMode: ThemeMode.system,
      home: ScaffoldWidget(
        child: Center(
          child: FailureWidget(
            failure: widget.failure,
            onRetryPressed: () {
              Restart.restartApp();
            },
          ),
        ),
      ),
    );
  }
}
