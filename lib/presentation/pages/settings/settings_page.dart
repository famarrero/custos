import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/theme_mode_extension.dart';
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

    return Column(
      children: [
        CustomTilesOptions(
          tiles: [
            CustomTile(
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

            CustomTile(
              prefixIconPath: HugeIcons.strokeRoundedLanguageSkill,
              title: 'Language',
              subtitle: 'Select your preferred language.',
              onTap: () {},
            ),

            CustomTile(
              prefixIconPath: HugeIcons.strokeRoundedShield01,
              title: 'Privacy policy',
              subtitle: 'Review the privacy policy of the app.',
              onTap: () {
                context.showCustomModalBottomSheet(
                  child: PrivacyPoliceWidget(),
                );
              },
            ),

            CustomTile(
              prefixIconPath: HugeIcons.strokeRoundedDelete01,
              title: 'Remove profile',
              subtitle: 'Delete the current profile.',
              onTap: () {
                context.showConfirmationDialog(
                  title:
                      '¿Estás seguro que deseas eliminar este perfil? ¡Esta acción no se puede deshacer!',
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
                  checkBoxTitle: '¡Sí, estoy seguro!',
                );
              },
            ),

            CustomTile(
              prefixIconPath: HugeIcons.strokeRoundedInformationCircle,
              title: 'About us',
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}
