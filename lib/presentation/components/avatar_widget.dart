import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/color_scheme_extension.dart';
import 'package:custos/core/extensions/string_extension.dart';
import 'package:custos/core/utils/constants.dart';
import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    super.key,
    required this.color,
    required this.name,
    this.icon,
    this.compact = false,
  });

  final Color? color;
  final String name;
  final IconData? icon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:
            color?.withValues(alpha: 0.6) ??
            context.colorScheme.primary.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(kMobileCorner),
      ),
      child: Center(
        child:
            icon == null
                ? SizedBox.square(
                  dimension: compact ? 28 : 44.0,
                  child: Center(
                    child: Text(
                      name.firstLetterToUpperCase,
                      style: context.textTheme.titleMedium?.copyWith(
                        color: context.colorScheme.blackAndWith,
                      ),
                    ),
                  ),
                )
                : SizedBox.square(
                  dimension: compact ? 28 : 44.0,
                  child: Center(
                    child: Icon(
                      icon,
                      color: context.colorScheme.blackAndWith.withValues(
                        alpha: 0.8,
                      ),
                      size: compact ? 18 : 24.0,
                    ),
                  ),
                ),
      ),
    );
  }
}
