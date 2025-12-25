import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/constants.dart';
import 'package:custos/presentation/components/base_state_ui.dart';
import 'package:custos/presentation/components/custom_app_bar.dart';
import 'package:custos/presentation/components/custom_button.dart';
import 'package:custos/presentation/components/no_data_widget.dart';
import 'package:custos/presentation/components/scaffold_widget.dart';
import 'package:custos/presentation/cubit/auth/auth_cubit.dart';
import 'package:custos/presentation/pages/login/components/profile_tile.dart';
import 'package:custos/presentation/pages/login/cubit/login_cubit.dart';
import 'package:custos/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

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
          appBar: CustomAppBar(leading: const SizedBox.shrink()),
          padding: EdgeInsets.symmetric(
            vertical: kMobileVerticalPadding,
            horizontal: kMobileHorizontalPadding,
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

                  const SizedBox(height: 12.0),

                  Text(
                    context.l10n.loginSelectProfileSubtitle,
                    style: context.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 24.0),

                  Flexible(
                    child: BaseStateUi(
                      state: state.profiles,
                      onRetryPressed:
                          () => context.read<LoginCubit>().watchProfiles(),
                      noDataWidget: NoDataWidget(
                        iconData: HugeIcons.strokeRoundedUser02,
                        title: context.l10n.loginNoProfileTitle,
                        subtitle:
                            context.l10n.loginNoProfileSubtitle,
                      ),
                      onDataChild: (profiles) {
                        return ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24.0,
                            vertical: 2.0,
                          ),
                          itemCount: profiles.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 24);
                          },
                          itemBuilder: (context, index) {
                            return ProfileTile(profile: profiles[index]);
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24.0),

                  Text(
                    context.l10n.loginOrCreateOne,
                    style: context.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 24.0),

                  CustomButton(
                    prefixIconData: HugeIcons.strokeRoundedUserAdd01,
                    label: context.l10n.loginCreateProfileButton,
                    infiniteWidth: true,
                    onPressed: () {
                      context.push(RegisterRoute().location);
                    },
                  ),

                  const SizedBox(height: 24.0),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
