import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:custos/presentation/components/base_state_ui.dart';
import 'package:custos/presentation/components/custom_app_bar.dart';
import 'package:custos/presentation/components/custom_button.dart';
import 'package:custos/presentation/components/no_data_widget.dart';
import 'package:custos/presentation/components/scaffold_widget.dart';
import 'package:custos/presentation/cubit/auth/auth_cubit.dart';
import 'package:custos/presentation/pages/login/components/profile_tile.dart';
import 'package:custos/presentation/pages/login/cubit/login_cubit.dart';
import 'package:custos/routes/routes.dart';
import 'package:custos/core/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) => current.loginState.isError,
      listener: (context, state) {
        context.showSnackBar(
          isErrorMessage: true,
          message: context.localizeError(failure: state.loginState.error),
        );
      },
      child: BlocProvider(
        create: (context) => LoginCubit()..watchProfiles(),
        child: ScaffoldWidget(
          safeAreaTop: true,
          appBar: CustomAppBar(leading: const SizedBox.shrink()),
          padding: EdgeInsets.symmetric(
            vertical: context.xl,
            horizontal: context.xl,
          ),
          child: BlocBuilder<LoginCubit, LoginState>(
            builder: (context, state) {
              return Column(
                children: [
                  Text(
                    context.l10n.loginWelcomeBackTitle,
                    style: context.textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: context.lg),

                  Text(
                    context.l10n.loginSelectProfileSubtitle,
                    style: context.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: context.xxxl),

                  Flexible(
                    child: BaseStateUi(
                      state: state.profiles,
                      onRetryPressed:
                          () => context.read<LoginCubit>().watchProfiles(),
                      noDataWidget: NoDataWidget(
                        iconData: AppIcons.user,
                        title: context.l10n.loginNoProfileTitle,
                        subtitle: context.l10n.loginNoProfileSubtitle,
                      ),
                      onDataChild: (profiles) {
                        return ListView.separated(
                          itemCount: profiles.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(height: context.sm);
                          },
                          itemBuilder: (context, index) {
                            return ProfileTile(profile: profiles[index]);
                          },
                        );
                      },
                    ),
                  ),

                  SizedBox(height: context.xxxl),

                  Text(
                    context.l10n.loginOrCreateOne,
                    style: context.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: context.xxxl),

                  CustomButton(
                    prefixIconData: AppIcons.userAdd,
                    label: context.l10n.loginCreateProfileButton,
                    infiniteWidth: true,
                    onPressed: () {
                      context.push(RegisterRoute().location);
                    },
                  ),

                  SizedBox(height: context.xxxl),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
