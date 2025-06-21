import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/go_router_extension.dart';
import 'package:custos/presentation/components/custom_circular_progress_indicator.dart';
import 'package:custos/presentation/components/custom_icon_button.dart';
import 'package:custos/presentation/components/custom_navigation_bar/custom_navigation_bar.dart';
import 'package:custos/presentation/components/scaffold_widget.dart';
import 'package:custos/presentation/cubit/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

class WrapperMainPage extends StatelessWidget {
  const WrapperMainPage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      safeAreaTop: true,
      appBar: AppBar(
        title: Text(context.router.appBarTitle),
        centerTitle: true,
        actions: [
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state.loginState.isLoading) {
                return CustomCircularProgressIndicator(dimension: 24);
              } else {
                return CustomIconButton(
                  icon: HugeIcons.strokeRoundedDelete02,
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
                );
              }
            },
          ),

          const SizedBox(width: 18.0),

          CustomIconButton(
            icon: HugeIcons.strokeRoundedLogout02,
            onTap: () {
              context.read<AuthCubit>().logout(GoRouter.of(context));
            },
          ),
        ],
        actionsPadding: EdgeInsets.all(14.0),
      ),
      bottomNavigationBar: CustomNavigationBar(),
      child: child,
    );
  }
}
