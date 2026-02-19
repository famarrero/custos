import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/string_extension.dart';
import 'package:custos/core/utils/app_icons.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:custos/presentation/components/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.leading,
    this.title,
    this.titleString,
    this.actions,
  });

  final Widget? leading;
  final Widget? title;
  final String? titleString;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading:
          leading ??
          (context.canPop()
              ? CustomIconButton(
                icon: AppIcons.back,
                onTap: () {
                  context.pop();
                },
              )
              : null),
      title:
          titleString.isNotNullAndNotEmpty
              ? Text(titleString!, style: context.textTheme.titleMedium)
              : title,
      centerTitle: true,
      elevation: 0.0,
      scrolledUnderElevation: 0.0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      actions: actions,
      actionsPadding: EdgeInsets.symmetric(horizontal: context.xxl),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, kToolbarHeight);
}
