import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, this.leading, this.title, this.actions});

  final Widget? leading;
  final Widget? title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading:
          leading ??
          (context.canPop()
              ? IconButton(
                icon: Icon(HugeIcons.strokeRoundedArrowLeft01),
                onPressed: () {
                  context.pop();
                },
              )
              : null),
      title: title,
      centerTitle: true,
      elevation: 0.0,
      scrolledUnderElevation: 0.0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      actions: actions,
      actionsPadding: EdgeInsets.all(14.0),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, kToolbarHeight);
}
