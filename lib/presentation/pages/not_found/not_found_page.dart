import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/constants.dart';
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
        horizontal: kMobileHorizontalPadding,
        vertical: kMobileVerticalPadding,
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
          const SizedBox(height: 8.0),
          Text(
            context.l10n.pageNotFoundSubtitle,
            style: context.textTheme.labelMedium?.copyWith(),
          ),
          const SizedBox(height: 12.0),
          CustomButton(label: context.l10n.goBack, onPressed: () => context.pop()),
        ],
      ),
    );
  }
}
