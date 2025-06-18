import 'package:custos/core/utils/app_error.dart';
import 'package:custos/core/utils/constants.dart';
import 'package:custos/core/utils/failures.dart';
import 'package:custos/presentation/app/l10n/app_localizations.dart';
import 'package:custos/presentation/app/theme/app_theme.dart';
import 'package:custos/presentation/components/custom_bottom_modal_sheet.dart';
import 'package:flutter/material.dart';

/// Extension for [BuildContext] to facilitate access to our [AppLocalizations], [Theme] and others.
extension BuildContextExtension on BuildContext {
  /// Gets the [AppLocalizations] object used to access localized text assets.
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// Get the current language locale
  String get languageCode => Localizations.localeOf(this).languageCode;

  /// Get the current locale used on app.
  Locale get locale => Localizations.localeOf(this);

  /// Gets the [ThemeData] of the app, equal to `Theme.of(context)`.
  ThemeData get theme => Theme.of(this);

  /// Gets the [TextTheme] of the app, equal to `Theme.of(context).textTheme`.
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Gets the [ColorScheme] of the app, equal to `Theme.of(context).colorScheme`.
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Gets the [AppTheme] as a [ThemeExtension] from the current theme.
  AppTheme get extension => Theme.of(this).extension<AppTheme>()!;

  /// Gets the [MediaQueryData] of the screen.
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Gets the full [Size] of the screen.
  Size get fullSize => mediaQuery.size;

  /// Gets the [fullHeight] of the screen.
  double get fullHeight => fullSize.height;

  /// Gets the [fullWidth] of the screen.
  double get fullWidth => fullSize.width;

  /// Displays an internationalized message according to the code passed as a parameter
  /// If the code is not found, a generic message is returned.
  String localizeError({required Failure failure}) {
    if (failure.message != null) {
      return failure.message!;
    } else {
      switch (failure.code) {
        case AppError.unknown:
          return l10n.unknownErrorOccurred;
        case AppError.errorDerivingEncryptionKey:
          return l10n.masterKeyErrorSet;
        case AppError.encryptionKeyNotSet:
          return l10n.masterKeyNotSet;
        case AppError.incorrectMasterKey:
          return l10n.incorrectMasterKey;
      }
    }
  }

  /// Displays a custom [SnackBar] hidden the current one
  ///
  /// -`message`: The message to be displayed in the SnackBar.
  /// -`isErrorMessage` by default `false`: Indicates whether the message is an error. If `true`,
  /// a [colorScheme.tertiaryContainer] background color will be applied.
  /// -`adaptiveVariant`: An instance of `AdaptiveVariant` that determines the
  /// width according to the variant
  void showSnackBar({
    required String message,
    bool isErrorMessage = false,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          // Set the duration of the SnackBar
          duration: const Duration(seconds: 3),

          // Set the dismiss direction
          dismissDirection: DismissDirection.horizontal,

          // Set the shape of the SnackBar
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

          // Set the background color of the SnackBar
          backgroundColor:
              backgroundColor ??
              (isErrorMessage ? colorScheme.error : colorScheme.secondary),

          // Set the behavior of the SnackBar
          behavior: SnackBarBehavior.floating,

          width: mediaQuery.size.width - kMobileHorizontalPadding * 2,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),

          // Set the content of the SnackBar
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(color: Colors.white),
          ),
        ),
      );
  }

  /// Show a custom ModalBottomSheet
  void showCustomModalBottomSheet({
    double? heightFactor,
    String? title,
    bool isDismissible = true,
    bool enableDrag = true,
    bool showScrollBar = false,
    required Widget child,
  }) {
    showModalBottomSheet<dynamic>(
      context: this,
      useSafeArea: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      constraints: const BoxConstraints(maxWidth: double.infinity),
      useRootNavigator: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return CustomBottomModalSheet(
          heightFactor: heightFactor,
          title: title,
          showScrollBar: showScrollBar,
          child: child,
        );
      },
    );
  }
}
