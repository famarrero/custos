import 'package:custos/core/utils/app_error.dart';
import 'package:custos/core/utils/failures.dart';
import 'package:custos/data/repositories/preferences/preferences_repository.dart';
import 'package:custos/di_container.dart';
import 'package:custos/presentation/app/custos_app.dart';
import 'package:custos/presentation/app/custos_error_app.dart';
import 'package:custos/presentation/cubit/app/app_cubit.dart';
import 'package:custos/presentation/cubit/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  // Some packages require this in order to be initialized.
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  try {
    // Initializing dependency injection.
    await initInjection();

    // Getting the theme mode from the preferences.
    // If no theme found use the theme of OS
    final themeMode =
        await di<PreferencesRepository>().getThemeMode() ??
        (WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                Brightness.dark
            ? ThemeMode.dark
            : ThemeMode.light);

    // Getting the locale from the preferences.
    final locale = await di<PreferencesRepository>().getLocale(
      defaultLocale: WidgetsBinding.instance.platformDispatcher.locale,
    );

    // Block landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]).then((_) {
      runApp(
        MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => AppCubit(themeMode: themeMode, locale: locale),
            ),
            BlocProvider(create: (_) => AuthCubit()),
          ],
          child: const CustosApp(),
        ),
      );
    });
  } catch (e) {
    runApp(
      CustosErrorApp(
        failure: AppFailure(AppError.unknown, message: e.toString()),  
      ),
    );
  }
}
