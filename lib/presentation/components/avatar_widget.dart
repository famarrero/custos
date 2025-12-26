import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/string_extension.dart';
import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    super.key,
    required this.color,
    required this.name,
    this.icon,
    this.compact = false,
    this.size,
  });

  final Color? color;
  final String name;
  final IconData? icon;
  final bool compact;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:
            color?.withValues(alpha: 0.2) ??
            context.colorScheme.primary.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: Center(
        child:
            icon == null
                ? SizedBox.square(
                  dimension: size ?? (compact ? 28 : 54.0),
                  child: Center(
                    child: Text(
                      name.firstLetterToUpperCase,
                      style: context.textTheme.titleMedium?.copyWith(
                        color: color,
                      ),
                    ),
                  ),
                )
                : SizedBox.square(
                  dimension: size ?? (compact ? 28 : 44.0),
                  child: Center(
                    child: Icon(
                      icon,
                      color: color,
                      size: (compact ? 18 : 24.0),
                    ),
                  ),
                ),
      ),
    );
  }
}
