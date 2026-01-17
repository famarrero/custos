import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/datetime_extension.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:custos/data/models/profile/profile_model.dart';
import 'package:custos/presentation/components/avatar_widget.dart';
import 'package:custos/presentation/components/custom_container.dart';
import 'package:custos/presentation/components/custom_inkwell.dart';
import 'package:custos/presentation/components/loading_dialog/loading_dialog.dart';
import 'package:custos/presentation/cubit/auth/auth_cubit.dart';
import 'package:custos/presentation/pages/login/components/login_profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileTile extends StatelessWidget {
  const ProfileTile({super.key, required this.profile});

  final ProfileModel profile;

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      padding: EdgeInsets.zero,
      onTap: () async {
        // Si la biométrica está habilitada, intentar login biométrico primero
        if (profile.hasBiometricEnabled) {
          // Mostrar diálogo de carga mientras se procesa el login biométrico
          if (context.mounted) {
            LoadingDialog.show(context);
          }

          try {
            final authCubit = context.read<AuthCubit>();
            final loginSuccess = await authCubit.loginWithBiometric(GoRouter.of(context), profile: profile);

            // Cerrar diálogo de carga
            if (context.mounted) {
              LoadingDialog.hide(context);
            }

            // Si el login biométrico fue exitoso, no mostrar el diálogo de login
            if (loginSuccess) {
              return;
            }
            // Si falló, continuar con el diálogo de login normal
          } catch (e) {
            // Cerrar diálogo de carga si hay error
            if (context.mounted) {
              LoadingDialog.hide(context);
            }
          }
        }

        if (context.mounted) {
          // Mostrar diálogo de login con master key
          context.showCustomGeneralDialog(child: LoginProfileWidget(profile: profile));
        }
      },
      child: CustomContainer(
        padding: EdgeInsets.symmetric(horizontal: context.xl, vertical: context.xl),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 16.0,
          children: [
            AvatarWidget(color: Colors.blue, name: profile.name),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(profile.name, style: context.textTheme.bodyLarge),
                  Text(profile.createdAt.formatDate, style: context.textTheme.labelSmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
