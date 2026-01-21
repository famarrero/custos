import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:custos/presentation/components/custom_container.dart';
import 'package:custos/presentation/components/custom_inkwell.dart';
import 'package:flutter/material.dart';

class AboutUsWidget extends StatelessWidget {
  const AboutUsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: EdgeInsets.all(context.xxxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('Codemundus studio', style: context.textTheme.titleMedium)],
          ),
          Text(
            'Independent Software Development Studio',
            style: context.textTheme.labelSmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.md),
          CustomInkWell(
            // onTap: () => di<UrlLauncherService>().launchUrl(Uri.parse('mailto:codemundus@gmail.com')),
            child: Text(
              'codemundus@gmail.com',
              style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.primary),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: context.md),
          Text('© 2026 All rights reserved', style: context.textTheme.labelSmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
