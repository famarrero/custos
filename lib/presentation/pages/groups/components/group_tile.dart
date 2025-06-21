import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/constants.dart';
import 'package:custos/data/models/group/group_model.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class GroupTile extends StatelessWidget {
  const GroupTile({super.key, required this.group});

  final GroupModel group;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 22.0,
      children: [
        Container(
          decoration: BoxDecoration(
            color: context.colorScheme.primary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(kMobileCorner),
          ),
          padding: EdgeInsets.all(12.0),
          child: Icon(
            HugeIcons.strokeRoundedHome01,
            color: Colors.black.withValues(alpha: 0.8),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2.0,
            children: [Text(group.name, style: context.textTheme.bodyLarge)],
          ),
        ),
      ],
    );
  }
}
