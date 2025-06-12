part of 'app_cubit.dart';

@freezed
abstract class AppState with _$AppState {
  const AppState._();

  const factory AppState({
    required String flavor,
    required ThemeMode themeMode,
    required Locale locale,
    required bool devicePreviewState,
  }) = _AppState;

  bool get isDarkMode => themeMode == ThemeMode.dark;
}
