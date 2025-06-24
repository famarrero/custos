import 'package:custos/core/app_environment.dart';
import 'package:custos/core/utils/app_error.dart';
import 'package:custos/core/utils/constants.dart';
import 'package:custos/core/utils/failures.dart';
import 'package:custos/presentation/app/l10n/app_localizations.dart';
import 'package:custos/presentation/app/theme/app_theme.dart';
import 'package:custos/presentation/components/confirmation_dialog.dart';
import 'package:custos/presentation/components/custom_bottom_modal_sheet.dart';
import 'package:custos/presentation/components/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Extension for [BuildContext] to facilitate access to our [AppLocalizations], [Theme] and others.
extension BuildContextExtension on BuildContext {
  /// Gets the [AppLocalizations] object used to access localized text assets.
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// Get the current language locale
  String get languageCode => Localizations.localeOf(this).languageCode;

  /// Get the current route instance
  GoRouter get router => GoRouter.of(this);

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
      return AppEnvironment.isDevOrDebugMode
          ? failure.message!
          : l10n.unknownErrorOccurred;
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
        case AppError.contentNotFound:
          return l10n.contentNotFound;
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
  Future<T?> showCustomModalBottomSheet<T>({
    double? heightFactor,
    String? title,
    bool isDismissible = true,
    bool enableDrag = true,
    bool showScrollBar = false,
    required Widget child,
  }) async {
    return await showModalBottomSheet<T>(
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

  /// Show confirmation dialog
  Future showConfirmationDialog({
    String? title,
    Widget? child,
    String? checkBoxTitle,
    String? labelLeftButton,
    Color? disabledForegroundColorLeft,
    Color? disableForegroundColorRight,
    Color? foregroundColorLeft,
    Color? backgroundColorLeft,
    Color? disableBackgroundColorLeft,
    Color? disableBackgroundColorRight,
    Function(bool check)? onPressedLeftButton,
    bool enableLeftButtonOnCheckOnly = false,
    bool enableRightButtonOnCheckOnly = false,
    String? labelRightButton,
    Color? disabledForegroundColorRight,
    Color? foregroundColorRight,
    Color? backgroundColorRight,
    Function(bool check)? onPressedRightButton,
    bool barrierDismissible = true,
  }) async => await showGeneralDialog(
    context: this,
    barrierLabel: '',
    barrierDismissible: barrierDismissible,
    transitionDuration: const Duration(milliseconds: 150),
    pageBuilder: (context, anim1, anim2) {
      return ConfirmationDialog(
        title: title,
        checkBoxTitle: checkBoxTitle,
        labelLeftButton: labelLeftButton,
        disabledForegroundColorLeft: disabledForegroundColorLeft,
        foregroundColorLeft: foregroundColorLeft,
        backgroundColorLeft: backgroundColorLeft,
        disableBackgroundColorLeft: disableBackgroundColorLeft,
        onPressedLeftButton: onPressedLeftButton,
        labelRightButton: labelRightButton,
        disabledForegroundColorRight: disabledForegroundColorRight,
        foregroundColorRight: foregroundColorRight,
        disableBackgroundColorRight: disableBackgroundColorRight,
        backgroundColorRight: backgroundColorRight,
        onPressedRightButton: onPressedRightButton,
        enableLeftButtonOnCheckOnly: enableLeftButtonOnCheckOnly,
        enableRightButtonOnCheckOnly: enableRightButtonOnCheckOnly,
        child: child,
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return _DialogAnimation(animation: anim1, child: child);
    },
  );

  /// Show general dialog
  Future showCustomGeneralDialog({
    String? title,
    required Widget child,
  }) async => await showDialog(
    context: this,
    barrierLabel: '',
    barrierDismissible: true,
    builder: (context) {
      return CustomDialog(title: title, child: child);
    },
  );
}

/// A widget that animates its child when shown.
/// This widget is particularly useful for showing alert dialogs.
///
/// * A fade transition that starts with 0 opacity and ends with 1 opacity.
/// * A slide transition that starts with an offset of (1, 0) and ends with an offset of (0, 0).
///
/// This widget uses a fade transition with a `Curves.bounceIn` curve to create a noticeable but smooth appearance.
/// The slide transition uses a `Curves.easeIn` curve for a more subtle animation.
///
/// The `child` parameter specifies the widget to be animated.
///
/// The `animation` parameter specifies the animation that drives the animation of the widget.
class _DialogAnimation extends StatelessWidget {
  const _DialogAnimation({required this.child, required this.animation});

  final Widget child;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).chain(CurveTween(curve: Curves.easeInCubic)).animate(animation),
      child: SlideTransition(
        position: Tween(
          begin: const Offset(0, -0.1),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeIn)).animate(animation),
        child: child,
      ),
    );
  }
}
