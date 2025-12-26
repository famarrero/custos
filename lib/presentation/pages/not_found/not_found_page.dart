import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:custos/presentation/components/custom_app_bar.dart';
import 'package:custos/presentation/components/custom_button.dart';
import 'package:custos/presentation/components/scaffold_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      safeAreaTop: true,
      appBar: CustomAppBar(),
      padding: EdgeInsets.symmetric(
        horizontal: context.xxxl,
        vertical: context.xxxl,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '404',
            style: context.textTheme.displayLarge?.copyWith(
              color: context.colorScheme.error,
              fontSize: context.textTheme.displayLarge!.fontSize! * 2,
              fontStyle: FontStyle.italic
            ),
          ),
          Text(
            context.l10n.pageNotFound,
            style: context.textTheme.titleSmall?.copyWith(),
          ),
          SizedBox(height: context.m),
          Text(
            context.l10n.pageNotFoundSubtitle,
            style: context.textTheme.labelMedium?.copyWith(),
          ),
          SizedBox(height: context.lg),
          CustomButton(
            label: context.l10n.goBack,
            onPressed: () => context.pop(),
          ),
        ],
      ),
    );
  }
}
