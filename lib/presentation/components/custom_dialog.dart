import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/string_extension.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({super.key, this.title, required this.child});

  final String? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(context.xxxl),
      child: Padding(
        padding: EdgeInsets.all(context.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: context.xxxl,
          children: [
            if (title.isNotNullAndNotEmpty)
              Text(title!, style: context.textTheme.titleMedium),
            child,
          ],
        ),
      ),
    );
  }
}
