import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:custos/core/utils/app_icons.dart';
import 'package:custos/presentation/app/l10n/app_localizations.dart';
import 'package:custos/presentation/cubit/app/app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';

class ChangeLanguageWidget extends StatelessWidget {
  const ChangeLanguageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.read<AppCubit>().state.locale;

    String getLocaleName(Locale locale) {
      final localeNames = LocaleNames.of(context);
      return (localeNames?.nameOf(locale.toLanguageTag()) ??
          locale.toLanguageTag());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...AppLocalizations.supportedLocales.map(
          (locale) => Material(
            child: InkWell(
              borderRadius: BorderRadius.circular(context.corner()),
              onTap: () {
                context.read<AppCubit>().onLocaleChanged(locale: locale);
                context.pop();
              },
              child: Padding(
                padding: EdgeInsets.all(context.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getLocaleName(locale),
                      style: context.textTheme.bodyMedium,
                    ),
                    if (currentLocale == locale)
                      Icon(AppIcons.success),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
