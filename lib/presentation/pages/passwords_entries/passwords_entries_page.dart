import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/constants.dart';
import 'package:custos/presentation/components/base_state_ui.dart';
import 'package:custos/presentation/components/custom_icon_button.dart';
import 'package:custos/presentation/components/form/custom_text_form_field.dart';
import 'package:custos/presentation/components/no_data_widget.dart';
import 'package:custos/presentation/components/scaffold_widget.dart';
import 'package:custos/presentation/cubit/auth/auth_cubit.dart';
import 'package:custos/presentation/pages/passwords_entries/components/group_filters.dart';
import 'package:custos/presentation/pages/passwords_entries/components/password_entry_tile.dart';
import 'package:custos/presentation/pages/passwords_entries/cubit/passwords_entries_cubit.dart';
import 'package:custos/presentation/pages/upsert_password_entry/cubit/upsert_password_entry_cubit.dart';
import 'package:custos/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

class PasswordsEntriesPage extends StatefulWidget {
  const PasswordsEntriesPage({super.key});

  @override
  State<PasswordsEntriesPage> createState() => _PasswordsEntriesPageState();
}

class _PasswordsEntriesPageState extends State<PasswordsEntriesPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PasswordsEntriesCubit(),
      child:
      // Check if user authenticated and watchPasswordsEntries
      BlocListener<AuthCubit, AuthState>(
        listenWhen:
            (previous, current) =>
                previous.loginState != current.loginState &&
                current.isUserAuthenticated,
        listener: (context, state) {
          context.read<PasswordsEntriesCubit>()
            ..watchPasswordsEntries()
            ..watchGroups();
        },
        child: ScaffoldWidget(
          floatingActionButton: FloatingActionButton(
            child: Icon(HugeIcons.strokeRoundedAdd01),
            onPressed: () {
              context.push(
                UpsertPasswordEntryRoute(
                  id: UpsertPasswordEntryCubit.addUserId,
                ).location,
              );
            },
          ),
          padding: EdgeInsets.symmetric(vertical: kMobileVerticalPadding),
          child: BlocBuilder<PasswordsEntriesCubit, PasswordsEntriesState>(
            builder: (context, state) {
              return Column(
                children: [
                  // Search form
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kMobileHorizontalPadding,
                    ),
                    child: CustomTextFormField(
                      controller: _searchController,
                      hint: 'Search',
                      prefixIcon: Icon(HugeIcons.strokeRoundedSearch01),
                      suffixIcon: CustomIconButton(
                        icon: HugeIcons.strokeRoundedCancel01,
                        onTap: () {
                          context
                              .read<PasswordsEntriesCubit>()
                              .filterPasswordEntries(
                                query: null,
                                group: state.selectedGroup,
                              );
                          _searchController.text = '';
                        },
                      ),
                      onChanged: (value) {
                        context
                            .read<PasswordsEntriesCubit>()
                            .filterPasswordEntries(
                              query: value,
                              group: state.selectedGroup,
                            );
                      },
                    ),
                  ),

                  Expanded(
                    child: BaseStateUi(
                      state: state.passwordsEntries,
                      onRetryPressed:
                          () =>
                              context
                                  .read<PasswordsEntriesCubit>()
                                  .watchPasswordsEntries(),
                      noDataWidget: NoDataWidget(
                        iconData: HugeIcons.strokeRoundedKey01,
                        title: 'No passwords found',
                        subtitle:
                            'Create a password entry to manage your accounts.',
                      ),
                      onDataChild: (passwordsEntries) {
                        return Column(
                          children: [
                            const SizedBox(height: 22.0),

                            Text(
                              'Accounts',
                              style: context.textTheme.headlineSmall,
                            ),

                            const SizedBox(height: 22.0),

                            GroupFilters(),

                            const SizedBox(height: 22.0),

                            if (passwordsEntries.isEmpty)
                              Expanded(
                                child: NoDataWidget(
                                  subtitle: 'No result for this filters',
                                  retryLabel: 'Clean filters',
                                  onRetryPressed: () {
                                    context
                                        .read<PasswordsEntriesCubit>()
                                        .filterPasswordEntries(
                                          group: PasswordsEntriesCubit.groupAll,
                                        );
                                  },
                                ),
                              )
                            else
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: kMobileHorizontalPadding,
                                  ),
                                  child: ListView.separated(
                                    separatorBuilder:
                                        (context, index) =>
                                            SizedBox(height: 18.0),
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: passwordsEntries.length,
                                    itemBuilder: (context, index) {
                                      return PasswordEntryTile(
                                        passwordEntry: passwordsEntries[index],
                                      );
                                    },
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
