import 'package:custos/presentation/components/custom_badge.dart';
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: GestureDetector(
                    onTap: () {
                      context
                          .read<PasswordsEntriesCubit>()
                          .filterPasswordEntries(
                            group: PasswordsEntriesCubit.groupAll,
                          );
                    },
                    child: CustomBadge(
                      text: PasswordsEntriesCubit.groupAll.name,
                      hideBackground:
                          state.selectedGroup?.id ==
                                  PasswordsEntriesCubit.groupAll.id
                              ? false
                              : true,
                    ),
                  ),
                ),
                ...state.groups.data.map(
                  (group) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
                        hideBackground:
                            state.selectedGroup?.id == group.id ? false : true,
                      ),
                    ),
                  ),
                ),
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
