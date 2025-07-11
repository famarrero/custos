import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/data/models/profile/profile_model.dart';
import 'package:custos/presentation/components/avatar_widget.dart';
import 'package:custos/presentation/pages/login/components/login_profile_widget.dart';
import 'package:flutter/material.dart';

class ProfileTile extends StatelessWidget {
  const ProfileTile({super.key, required this.profile});

  final ProfileModel profile;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.showCustomGeneralDialog(
          child: LoginProfileWidget(profile: profile),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 16.0,
        children: [
          AvatarWidget(color: Colors.blue, name: profile.name),
          Expanded(
            child: Text(profile.name, style: context.textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}
