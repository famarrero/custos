import 'package:custos/presentation/components/custom_badge.dart';
import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:custos/presentation/pages/passwords_entries/cubit/passwords_entries_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupFilters extends StatelessWidget {
  const GroupFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordsEntriesCubit, PasswordsEntriesState>(
      builder: (context, state) {
        if (state.groups.isData) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(width: context.xl),

                GestureDetector(
                  onTap: () {
                    context.read<PasswordsEntriesCubit>().filterPasswordEntries(
                      group: PasswordsEntriesCubit.groupAll,
                    );
                  },
                  child: CustomBadge(
                    text: context.l10n.allGroups,
                    isSelected:
                        state.selectedGroup?.id ==
                        PasswordsEntriesCubit.groupAll.id,
                  ),
                ),
                SizedBox(width: context.s),
                ...state.groups.data.map(
                  (group) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.s),
                    child: GestureDetector(
                      onTap: () {
                        context
                            .read<PasswordsEntriesCubit>()
                            .filterPasswordEntries(
                              query: state.query,
                              group: group,
                            );
                      },
                      child: CustomBadge(
                        icon: group.icon,
                        text: group.name,
                        color: group.color,
                        isSelected: state.selectedGroup?.id == group.id,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: context.xl),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
