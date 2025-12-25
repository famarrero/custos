import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/theme_mode_extension.dart';
import 'package:custos/core/services/package_info_service.dart';
import 'package:custos/di_container.dart';
import 'package:custos/presentation/components/change_language_widget.dart';
import 'package:custos/presentation/components/avatar_widget.dart';
import 'package:custos/presentation/components/custom_container.dart';
import 'package:custos/presentation/components/custom_tiles_options.dart';
import 'package:custos/presentation/components/privacy_police_widget.dart';
import 'package:custos/presentation/cubit/app/app_cubit.dart';
import 'package:custos/presentation/cubit/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = context.watch<AppCubit>().state.themeMode.isDarkMode;
    final profileName = context.select<AuthCubit, String?>(
      (cubit) => cubit.state.loginState.dataOrNull?.name,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Column(
        children: [
          if (profileName != null && profileName.trim().isNotEmpty) ...[
            Row(
              children: [
                AvatarWidget(color: null, name: profileName),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    profileName,
                    style: context.textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
          CustomContainer(
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 4.0,
            ),
            child: CustomTilesOptions(
              tiles: [
                CustomSettingTile(
                  prefixIconPath:
                      isDarkMode
                          ? HugeIcons.strokeRoundedMoon02
                          : HugeIcons.strokeRoundedSun02,
                  title: 'Theme mode',
                  subtitle: 'Choose between light and dark mode.',
                  onTap: () {
                    context.read<AppCubit>().onThemeChanged();
                  },
                ),

                CustomSettingTile(
                  prefixIconPath: HugeIcons.strokeRoundedLanguageSquare,
                  title: 'Language',
                  subtitle: 'Select your preferred language.',
                  onTap: () {
                    context.showCustomModalBottomSheet(
                      title: 'Change language',
                      child: ChangeLanguageWidget(),
                    );
                  },
                ),

                CustomSettingTile(
                  prefixIconPath: HugeIcons.strokeRoundedShield01,
                  title: 'Privacy policy',
                  subtitle: 'Review the privacy policy of the app.',
                  onTap: () {
                    context.showCustomModalBottomSheet(
                      child: PrivacyPoliceWidget(),
                    );
                  },
                ),

                CustomSettingTile(
                  prefixIconPath: HugeIcons.strokeRoundedDelete01,
                  title: 'Remove profile',
                  subtitle: 'Delete the current profile.',
                  onTap: () {
                    context.showConfirmationDialog(
                      title:
                          '¿Estás seguro que deseas eliminar este perfil? Esta acción no se puede deshacer.',
                      labelLeftButton: 'Cancel',
                      onPressedLeftButton: (_) => context.pop(),
                      labelRightButton: 'Delete',
                      backgroundColorRight: context.colorScheme.error,
                      onPressedRightButton: (value) {
                        if (value) {
                          context.read<AuthCubit>().deleteProfile(
                            GoRouter.of(context),
                          );
                          context.pop();
                        }
                      },
                      checkBoxTitle: '¡Estoy seguro!',
                    );
                  },
                ),

                CustomSettingTile(
                  prefixIconPath: HugeIcons.strokeRoundedInformationCircle,
                  title: 'About us',
                  onTap: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 38.0),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'custos',
                  style: context.textTheme.titleLarge?.copyWith(
                    color: context.colorScheme.primary,
                  ),
                ),
                Text(
                  'Versión ${di<PackageInfoService>().getAppVersion()}',
                  style: context.textTheme.labelSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
