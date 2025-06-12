import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';

class TypographyShowcase extends StatelessWidget {
  const TypographyShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    final styles = <MapEntry<String, TextStyle?>>[
      MapEntry('displayLarge', textTheme.displayLarge),
      MapEntry('displayMedium', textTheme.displayMedium),
      MapEntry('displaySmall', textTheme.displaySmall),
      MapEntry('headlineLarge', textTheme.headlineLarge),
      MapEntry('headlineMedium', textTheme.headlineMedium),
      MapEntry('headlineSmall', textTheme.headlineSmall),
      MapEntry('titleLarge', textTheme.titleLarge),
      MapEntry('titleMedium', textTheme.titleMedium),
      MapEntry('titleSmall', textTheme.titleSmall),
      MapEntry('bodyLarge', textTheme.bodyLarge),
      MapEntry('bodyMedium', textTheme.bodyMedium),
      MapEntry('bodySmall', textTheme.bodySmall),
      MapEntry('labelLarge', textTheme.labelLarge),
      MapEntry('labelMedium', textTheme.labelMedium),
      MapEntry('labelSmall', textTheme.labelSmall),
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: styles.length,
      itemBuilder: (context, index) {
        final entry = styles[index];
        final style = entry.value;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            '${entry.key} — ${style?.fontSize?.toStringAsFixed(1)}sp — weight ${style?.fontWeight?.value ?? 'null'}',
            style: style,
          ),
        );
      },
    );
  }
}
