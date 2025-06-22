import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/go_router_extension.dart';
import 'package:custos/presentation/components/custom_app_bar.dart';
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
      appBar: CustomAppBar(
        title: Text(context.router.appBarTitle),
        actions: [
          CustomIconButton(
            icon: HugeIcons.strokeRoundedLogout02,
            onTap: () {
              context.read<AuthCubit>().logout(GoRouter.of(context));
            },
          ),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(),
      child: child,
    );
  }
}
