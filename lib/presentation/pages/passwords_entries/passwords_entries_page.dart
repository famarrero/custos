import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/constants.dart';
import 'package:custos/presentation/components/base_state_ui.dart';
import 'package:custos/presentation/components/form/custom_text_form_field.dart';
import 'package:custos/presentation/components/no_data_widget.dart';
import 'package:custos/presentation/components/scaffold_widget.dart';
import 'package:custos/presentation/cubit/auth/auth_cubit.dart';
import 'package:custos/presentation/pages/passwords_entries/components/password_entry_tile.dart';
import 'package:custos/presentation/pages/passwords_entries/cubit/passwords_entries_cubit.dart';
import 'package:custos/presentation/pages/upsert_password_entry/cubit/upsert_password_entry_cubit.dart';
import 'package:custos/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

class PasswordsEntriesPage extends StatelessWidget {
  const PasswordsEntriesPage({super.key});

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
          context.read<PasswordsEntriesCubit>().watchPasswordsEntries();
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
          padding: EdgeInsets.symmetric(
            horizontal: kMobileHorizontalPadding,
            vertical: kMobileVerticalPadding,
          ),
          child: BlocBuilder<PasswordsEntriesCubit, PasswordsEntriesState>(
            builder: (context, state) {
              return BaseStateUi(
                state: state.passwordsEntries,
                onRetryPressed:
                    () =>
                        context
                            .read<PasswordsEntriesCubit>()
                            .watchPasswordsEntries(),
                noDataWidget: NoDataWidget(
                  iconData: HugeIcons.strokeRoundedKey01,
                  title: 'No passwords found',
                  subtitle: 'Create a password entry to manage your accounts.',
                ),
                onDataChild: (groups) {
                  return Column(
                    children: [
                      // Search form
                      CustomTextFormField(
                        hint: 'Search',
                        prefixIcon: Icon(HugeIcons.strokeRoundedSearch01),
                      ),

                      const SizedBox(height: 22.0),

                      Text('Accounts', style: context.textTheme.headlineSmall),

                      const SizedBox(height: 4.0),

                      Expanded(
                        child: ListView.separated(
                          separatorBuilder:
                              (context, index) => SizedBox(height: 18.0),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.passwordsEntries.data.length,
                          itemBuilder: (context, index) {
                            return PasswordEntryTile(
                              passwordEntry: state.passwordsEntries.data[index],
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
