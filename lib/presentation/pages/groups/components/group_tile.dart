import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:custos/data/models/group/group_entity.dart';
import 'package:custos/data/repositories/group/group_repository.dart';
import 'package:custos/di_container.dart';
import 'package:custos/presentation/components/avatar_widget.dart';
import 'package:custos/presentation/components/custom_container.dart';
import 'package:custos/presentation/components/custom_icon_button.dart';
import 'package:custos/presentation/components/upsert_group/upsert_group.dart';
import 'package:custos/core/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GroupTile extends StatelessWidget {
  const GroupTile({
    super.key,
    required this.group,
    this.compact = false,
    this.showDeleteButton = false,
    this.showEditButton = false,
  });

  final GroupEntity group;
  final bool compact;
  final bool showDeleteButton;
  final bool showEditButton;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: EdgeInsets.symmetric(
        vertical: context.lg,
        horizontal: context.xl,
      ),
      child: Row(
        spacing: context.md,
        children: [
          AvatarWidget(
            color: group.color,
            name: group.name,
            icon: group.icon,
            size: 40,
          ),
          Expanded(
            child: Text(
              group.name,
              style: context.textTheme.bodyLarge,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (showEditButton)
            CustomIconButton(
              icon: AppIcons.edit,
              backgroundColor: context.colorScheme.secondaryContainer,
              iconColor: context.colorScheme.onSecondaryContainer,
              iconSize: 18.0,
              onTap: () {
                context.showCustomGeneralDialog(
                  title: context.l10n.groupsEditGroupTitle,
                  child: UpsertGroup(group: group),
                );
              },
            ),
          if (showDeleteButton)
            CustomIconButton(
              icon: AppIcons.delete,
              backgroundColor: context.colorScheme.errorContainer,
              iconColor: context.colorScheme.onErrorContainer,
              iconSize: 18.0,
              onTap: () {
                context.showConfirmationDialog(
                  title: context.l10n.confirmDeleteGroupTitle,
                  labelLeftButton: context.l10n.cancel,
                  onPressedLeftButton: (value) {
                    context.pop();
                  },
                  labelRightButton: context.l10n.delete,
                  onPressedRightButton: (value) {
                    context.pop();
                    di<GroupRepository>().deleteGroup(id: group.id);
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}
