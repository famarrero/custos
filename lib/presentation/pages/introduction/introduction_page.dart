import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/app_icons.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:custos/data/repositories/preference/preference_repository.dart';
import 'package:custos/di_container.dart';
import 'package:custos/presentation/components/custom_app_bar.dart';
import 'package:custos/presentation/components/custom_button.dart';
import 'package:custos/presentation/components/scaffold_widget.dart';
import 'package:custos/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({super.key});

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  final PageController _pageController = PageController();
  static const int _pageCount = 5;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFirstTime = !context.canPop();

    return ScaffoldWidget(
      safeAreaTop: true,
      appBar: CustomAppBar(),
      padding: EdgeInsets.symmetric(horizontal: context.xl),
      child: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                _IntroSlide(
                  icon: AppIcons.groupMobile,
                  title: context.l10n.introductionSlide1Title,
                  body: context.l10n.introductionSlide1Body,
                ),
                _IntroSlide(
                  icon: AppIcons.groups,
                  title: context.l10n.introductionSlide2Title,
                  body: context.l10n.introductionSlide2Body,
                ),
                _IntroSlide(
                  icon: AppIcons.otp,
                  title: context.l10n.introductionSlide3Title,
                  body: context.l10n.introductionSlide3Body,
                ),
                _IntroSlide(
                  icon: AppIcons.analytics,
                  title: context.l10n.introductionSlide4Title,
                  body: context.l10n.introductionSlide4Body,
                ),
                _IntroSlide(
                  icon: AppIcons.groupBackup,
                  title: context.l10n.introductionSlide5Title,
                  body: context.l10n.introductionSlide5Body,
                ),
              ],
            ),
          ),
          SizedBox(height: context.lg),
          SmoothPageIndicator(
            controller: _pageController,
            count: _pageCount,
            effect: ExpandingDotsEffect(
              dotHeight: 8,
              dotWidth: 8,
              expansionFactor: 4,
              spacing: 8,
              dotColor: context.colorScheme.outline.withValues(alpha: 0.4),
              activeDotColor: context.colorScheme.primary,
            ),
          ),
          SizedBox(height: context.xxl),
          if (isFirstTime)
            CustomButton(
              label: context.l10n.introductionGetStarted,
              onPressed: () async {
                await di<PreferenceRepository>().setHasSeenIntroduction(value: true);
                if (!context.mounted) return;
                context.go(const LoginRoute().location);
              },
            )
          else
            CustomButton(
              label: 'Ok',
              onPressed: () async {
                context.pop();
              },
            ),

          SizedBox(height: context.xl),
        ],
      ),
    );
  }
}

class _IntroSlide extends StatelessWidget {
  const _IntroSlide({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.s),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(icon, size: 72, color: context.colorScheme.primary),
          SizedBox(height: context.xxl),
          Text(
            title,
            style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.lg),
          Text(
            body,
            style: context.textTheme.bodyLarge?.copyWith(color: context.colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
