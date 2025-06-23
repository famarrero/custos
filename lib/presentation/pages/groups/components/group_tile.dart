import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/color_scheme_extension.dart';
import 'package:custos/core/extensions/string_extension.dart';
import 'package:custos/core/utils/constants.dart';
import 'package:custos/data/models/group/group_entity.dart';
import 'package:flutter/material.dart';

class GroupTile extends StatelessWidget {
  const GroupTile({super.key, required this.group, this.compact = false});

  final GroupEntity group;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 22.0,
      children: [
        Container(
          decoration: BoxDecoration(
            color:
                group.color?.withValues(alpha: 0.6) ??
                context.colorScheme.primary.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(kMobileCorner),
          ),
          child:
              group.icon == null
                  ? SizedBox.square(
                    dimension: compact ? 28.0 : 44.0,
                    child: Center(
                      child: Text(
                        group.name.firstLetterToUpperCase,
                        style: context.textTheme.titleMedium?.copyWith(
                          color: context.colorScheme.blackAndWith,
                        ),
                      ),
                    ),
                  )
                  : SizedBox.square(
                    dimension: compact ? 28.0 : 44.0,
                    child: Center(
                      child: Icon(
                        group.icon,
                        color: context.colorScheme.blackAndWith.withValues(alpha: 0.8),
                        size: compact ? 18.0 : 24.0,
                      ),
                    ),
                  ),
        ),
        Expanded(
          child: Text(
            group.name,
            style: context.textTheme.bodyLarge,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
