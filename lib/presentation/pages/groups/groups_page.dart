import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/constants.dart';
import 'package:custos/presentation/components/base_state_ui.dart';
import 'package:custos/presentation/components/no_data_widget.dart';
import 'package:custos/presentation/components/scaffold_widget.dart';
import 'package:custos/presentation/components/upsert_group/upsert_group.dart';
import 'package:custos/presentation/pages/groups/components/group_tile.dart';
import 'package:custos/presentation/pages/groups/cubit/groups_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

class GroupsPage extends StatelessWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupsCubit()..watchGroups(),
      child: ScaffoldWidget(
        floatingActionButton: FloatingActionButton(
          child: Icon(HugeIcons.strokeRoundedAdd01),
          onPressed: () {
            context.showCustomGeneralDialog(
              title: context.l10n.groupsAddGroupTitle,
              child: UpsertGroup(),
            );
          },
        ),
        padding: EdgeInsets.symmetric(
          horizontal: kMobileHorizontalPadding,
          vertical: kMobileVerticalPadding,
        ),
        child: BlocBuilder<GroupsCubit, GroupsState>(
          builder: (context, state) {
            return BaseStateUi(
              state: state.groups,
              onRetryPressed: () => context.read<GroupsCubit>().watchGroups(),
              noDataWidget: NoDataWidget(
                iconData: HugeIcons.strokeRoundedGroup01,
                title: context.l10n.groupsNoGroupsTitle,
                subtitle: context.l10n.groupsNoGroupsSubtitle,
              ),
              onDataChild: (groups) {
                return ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 18.0),
                  itemCount: state.groups.data.length,
                  itemBuilder: (context, index) {
                    return GroupTile(
                      group: state.groups.data[index],
                      showEditButton: true,
                      showDeleteButton: true,
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
