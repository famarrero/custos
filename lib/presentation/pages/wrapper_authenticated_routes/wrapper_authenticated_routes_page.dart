import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/presentation/components/custom_icon_button.dart';
import 'package:custos/presentation/components/scaffold_widget.dart';
import 'package:custos/presentation/components/upsert_password_entry/upsert_password_entry.dart';
import 'package:flutter/material.dart';

class WrapperAuthenticatedRoutesPage extends StatelessWidget {
  const WrapperAuthenticatedRoutesPage({super.key, required this.child});

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
            icon: Icons.add,
            onTap: () {
              context.showCustomModalBottomSheet(
                title: 'Add account',
                child: UpsertPasswordEntry(),
              );
            },
          ),
        ],
        actionsPadding: EdgeInsets.all(14.0),
      ),
      child: child,
    );
  }
}
