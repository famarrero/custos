import 'package:custos/presentation/components/custom_icon_button.dart';
import 'package:custos/presentation/components/scaffold_widget.dart';
import 'package:custos/presentation/cubit/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class WrapperMainPage extends StatelessWidget {
  const WrapperMainPage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      safeAreaTop: true,
      appBar: AppBar(
        title: Text('Passwords'),
        centerTitle: true,
        actions: [
          CustomIconButton(
            icon: Icons.exit_to_app,
            onTap: () {
              context.read<AuthCubit>().logout(GoRouter.of(context));
            },
          ),
        ],
        actionsPadding: EdgeInsets.all(14.0),
      ),
      child: child,
    );
  }
}
