import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/device_type.dart';
import 'package:custos/presentation/app/l10n/app_localizations.dart';
import 'package:custos/presentation/app/theme/app_theme.dart';
import 'package:custos/presentation/cubit/app/app_cubit.dart';
import 'package:custos/routes/routes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

/// Main app widget in charge of creating [MaterialApp] along with localization delegates, routes and theme.
class CustosApp extends StatefulWidget {
  const CustosApp({super.key});

  @override
  State<CustosApp> createState() => _CustosAppState();
}

class _CustosAppState extends State<CustosApp> {
  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (_, state) {
        return MaterialApp.router(
          // Ensures that the mouse also serves as a drag device.
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {
              PointerDeviceKind.mouse,
              ...const MaterialScrollBehavior().dragDevices,
            },
          ),
          debugShowCheckedModeBanner: false,
          onGenerateTitle: (context) => context.l10n.custos,
          locale: state.locale,
          localizationsDelegates: const [
            ...AppLocalizations.localizationsDelegates,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          theme:
              AppTheme(
                themeMode: state.themeMode,
                deviceType: DeviceInfo.getDeviceType(context),
              ).toThemeData(),
          darkTheme:
              AppTheme(
                themeMode: state.themeMode,
                deviceType: DeviceInfo.getDeviceType(context),
              ).toThemeData(),
          themeMode: state.themeMode,
          routerConfig: router,
          builder: (context, child) {
            return child ?? const SizedBox();
          },
        );
      },
    );
  }
}
