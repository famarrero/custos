import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/data/models/profile/profile_model.dart';
import 'package:custos/presentation/pages/login/components/login_profile_widget.dart';
import 'package:flutter/material.dart';

class ProfileTile extends StatelessWidget {
  const ProfileTile({super.key, required this.profile});

  final ProfileModel profile;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.showCustomModalBottomSheet(
          child: LoginProfileWidget(profile: profile),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: Row(children: [Expanded(child: Text(profile.name))]),
      ),
    );
  }
}
