import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/presentation/components/scaffold_widget.dart';
import 'package:flutter/widgets.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      child: Center(
        child: Text(
          context.l10n.pageNotFound,
          style: context.textTheme.bodyLarge?.copyWith(
            color: context.colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }
}
