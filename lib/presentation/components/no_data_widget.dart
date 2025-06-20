import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/string_extension.dart';
import 'package:custos/presentation/components/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Widget to show in empty page
class NoDataWidget extends StatelessWidget {
  const NoDataWidget({
    super.key,
    this.title,
    this.subtitle,
    this.onRetryPressed,
    this.iconPath,
    this.iconData,
    this.titleStyle,
  });

  final String? title;

  final String? subtitle;

  /// Retry function
  final Function()? onRetryPressed;

  final String? iconPath;

  final IconData? iconData;

  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onRetryPressed,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconPath != null
                ? SvgPicture.asset(height: 30, width: 30, iconPath!)
                : const SizedBox.shrink(),
            iconData != null
                ? Icon(iconData, size: 30)
                : const SizedBox.shrink(),
            const SizedBox(height: 12),
            Text(
              title ?? '',
              style: titleStyle ?? context.textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
            if (subtitle.isNotNullAndNotEmpty) ...[
              const SizedBox(height: 2.0),
              Text(
                subtitle!,
                style: context.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetryPressed != null) ...[
              const SizedBox(height: 12.0),
              CustomIconButton(
                onTap: onRetryPressed != null ? onRetryPressed! : () {},
                icon: Icons.refresh,
                iconColor: context.colorScheme.secondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
