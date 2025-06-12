import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/app_error.dart';
import 'package:custos/core/utils/failures.dart';
import 'package:custos/presentation/components/custom_button.dart';
import 'package:flutter/material.dart';

/// Widget to show failures to the user when error occurred by passing a error code
class FailureWidget extends StatelessWidget {
  const FailureWidget({super.key, this.failure, this.onRetryPressed});

  /// The error code provided
  final Failure? failure;

  /// Retry function
  final Function()? onRetryPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              context.localizeError(
                failure: failure ?? const AppFailure(AppError.unknown),
              ),
              style: context.textTheme.labelMedium?.copyWith(
                color: context.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetryPressed != null) ...[
              const SizedBox(height: 8.0),
              CustomButton(
                infiniteWidth: true,
                onPressed: onRetryPressed,
                label: context.l10n.retry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
