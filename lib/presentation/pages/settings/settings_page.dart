import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/datetime_extension.dart';
import 'package:custos/core/extensions/theme_mode_extension.dart';
import 'package:custos/core/services/package_info_service.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:custos/core/utils/app_icons.dart';
import 'package:custos/data/models/profile/profile_model.dart';
import 'package:custos/data/repositories/version/version_repository.dart';
import 'package:custos/di_container.dart';
import 'package:custos/presentation/components/change_language_widget.dart';
import 'package:custos/presentation/components/avatar_widget.dart';
import 'package:custos/presentation/components/custom_container.dart';
import 'package:custos/presentation/components/custom_tiles_options.dart';
import 'package:custos/presentation/components/import_export/cubit/import_export_data_cubit.dart';
import 'package:custos/presentation/components/import_export/import_export_data.dart';
import 'package:custos/presentation/components/privacy_police_widget.dart';
import 'package:custos/presentation/cubit/app/app_cubit.dart';
import 'package:custos/presentation/cubit/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = context.watch<AppCubit>().state.themeMode.isDarkMode;
    final profile = context.select<AuthCubit, ProfileModel?>(
      (cubit) => cubit.state.loginState.dataOrNull,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.xl),
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (profile?.name != null && profile!.name.trim().isNotEmpty) ...[
              Row(
                children: [
                  AvatarWidget(color: null, name: profile.name),
                  SizedBox(width: context.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.name,
                          style: context.textTheme.titleLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Creado el ${profile.createdAt.toLocal().formatDate}',
                          style: context.textTheme.labelMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        FutureBuilder(
                          future: di<VersionRepository>().getVersion(),
                          builder: (context, asyncSnapshot) {
                            return Text(
                              'Data base version: ${asyncSnapshot.data?.version ?? 0}',
                              style: context.textTheme.labelMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            );
                          }
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.xxxl),
            ],
            CustomContainer(
              child: CustomTilesOptions(
                tiles: [
                  CustomSettingTile(
                    prefixIconPath:
                        isDarkMode ? AppIcons.darkMode : AppIcons.lightMode,
                    title: context.l10n.settingsThemeModeTitle,
                    subtitle: context.l10n.settingsThemeModeSubtitle,
                    onTap: () {
                      context.read<AppCubit>().onThemeChanged();
                    },
                  ),

                  CustomSettingTile(
                    prefixIconPath: AppIcons.language,
                    title: context.l10n.settingsLanguageTitle,
                    subtitle: context.l10n.settingsLanguageSubtitle,
                    onTap: () {
                      context.showCustomModalBottomSheet(
                        title: context.l10n.settingsChangeLanguageTitle,
                        child: ChangeLanguageWidget(),
                      );
                    },
                  ),

                  CustomSettingTile(
                    prefixIconPath: AppIcons.groupBackup,
                    title: 'Import/Export',
                    subtitle: 'Importa y exporta tus datos',
                    onTap: () {
                      context.showCustomModalBottomSheet(
                        title: 'Importa y exporta tus datos',
                        child: BlocProvider<ImportExportDataCubit>(
                          create: (context) => ImportExportDataCubit(),
                          child: ImportExportDataWidget(),
                        ),
                      );
                    },
                  ),

                  CustomSettingTile(
                    prefixIconPath: AppIcons.shield,
                    title: context.l10n.settingsPrivacyPolicyTitle,
                    subtitle: context.l10n.settingsPrivacyPolicySubtitle,
                    onTap: () {
                      context.showCustomModalBottomSheet(
                        child: PrivacyPoliceWidget(),
                      );
                    },
                  ),

                  CustomSettingTile(
                    prefixIconPath: AppIcons.delete,
                    title: context.l10n.settingsRemoveProfileTitle,
                    subtitle: context.l10n.settingsRemoveProfileSubtitle,
                    onTap: () {
                      context.showConfirmationDialog(
                        title: context.l10n.settingsRemoveProfileConfirmTitle,
                        labelLeftButton: context.l10n.cancel,
                        onPressedLeftButton: (_) => context.pop(),
                        labelRightButton: context.l10n.delete,
                        backgroundColorRight: context.colorScheme.error,
                        onPressedRightButton: (value) {
                          if (value) {
                            context.read<AuthCubit>().deleteProfile(
                              GoRouter.of(context),
                            );
                            context.pop();
                          }
                        },
                        checkBoxTitle:
                            context.l10n.settingsRemoveProfileConfirmCheckbox,
                      );
                    },
                  ),

                  CustomSettingTile(
                    prefixIconPath: AppIcons.info,
                    title: context.l10n.settingsAboutUsTitle,
                    subtitle: 'Informacion de la aplicacion',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            SizedBox(height: context.xxxl),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.xxxl + context.s,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.custos,
                    style: context.textTheme.titleLarge?.copyWith(
                      color: context.colorScheme.primary,
                    ),
                  ),
                  Text(
                    context.l10n.appVersion(
                      di<PackageInfoService>().getAppVersion(),
                    ),
                    style: context.textTheme.labelSmall,
                  ),
                ],
              ),
            ),

            SizedBox(height: context.xxxl),

            // if (AppEnvironment.isDevOrDebugMode) TypographyShowcase(),
          ],
        ),
      ),
    );
  }
}
