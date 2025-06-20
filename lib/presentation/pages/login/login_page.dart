import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/constants.dart';
import 'package:custos/presentation/components/base_state_ui.dart';
import 'package:custos/presentation/components/custom_button.dart';
import 'package:custos/presentation/components/no_data_widget.dart';
import 'package:custos/presentation/components/scaffold_widget.dart';
import 'package:custos/presentation/cubit/auth/auth_cubit.dart';
import 'package:custos/presentation/pages/login/cubit/login_cubit.dart';
import 'package:custos/routes/routes.dart';
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
          padding: EdgeInsets.symmetric(
            vertical: kMobileVerticalPadding,
            horizontal: kMobileHorizontalPadding,
          ),
          child: BlocBuilder<LoginCubit, LoginState>(
            builder: (context, state) {
              return Column(
                children: [
                  Flexible(
                    child: BaseStateUi(
                      state: state.profiles,
                      onRetryPressed:
                          () => context.read<LoginCubit>().watchProfiles(),
                      noDataWidget: NoDataWidget(
                        iconData: Icons.person,
                        title: 'No profile yet',
                        subtitle:
                            'When you create a profile they will appear here. Clink in Create profile button to add.',
                      ),
                      onDataChild: (profiles) {
                        return ListView.builder(
                          itemCount: profiles.length,
                          itemBuilder: (context, index) {
                            return Text(profiles[index].name);
                          },
                        );
                      },
                    ),
                  ),
                  CustomButton(
                    prefixIconData: Icons.person_add,
                    label: 'Create profile',
                    infiniteWidth: true,
                    onPressed: () {
                      context.push(RegisterRoute().location);
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
