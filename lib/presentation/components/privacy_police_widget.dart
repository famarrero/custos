import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/root_bundle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

class PrivacyPoliceWidget extends StatelessWidget {
  const PrivacyPoliceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: loadPrivacyPolicy(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error loading privacy policy: ${snapshot.error}');
        } else {
          return MarkdownBody(
            data: snapshot.data!,
            styleSheet: MarkdownStyleSheet(
              a: context.textTheme.bodySmall,
              h1: context.textTheme.titleMedium,
              h2: context.textTheme.titleSmall,
              h3: context.textTheme.titleSmall,
              strong: context.textTheme.titleSmall,
            ),
          );
        }
      },
    );
  }
}
