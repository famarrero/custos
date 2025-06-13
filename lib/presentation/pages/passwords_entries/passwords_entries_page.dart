import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/constants.dart';
import 'package:custos/presentation/components/form/custom_text_form_field.dart';
import 'package:custos/presentation/components/scaffold_widget.dart';
import 'package:custos/presentation/pages/passwords_entries/components/password_entry_tile.dart';
import 'package:custos/presentation/pages/passwords_entries/cubit/passwords_entries_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordsEntriesPage extends StatelessWidget {
  const PasswordsEntriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PasswordsEntriesCubit()..getPasswordsEntries(),
      child: ScaffoldWidget(
        padding: EdgeInsets.symmetric(
          horizontal: kMobileHorizontalPadding,
          vertical: kMobileVerticalPadding,
        ),
        child: BlocBuilder<PasswordsEntriesCubit, PasswordsEntriesState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Search form
                CustomTextFormField(
                  hint: 'Search',
                  prefixIcon: Icon(Icons.search),
                ),

                const SizedBox(height: 22.0),

                Text('Accounts', style: context.textTheme.headlineSmall),

                // List of passwords entries
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 22.0),
                      child: ListView.separated(
                        separatorBuilder:
                            (context, index) => SizedBox(height: 18.0),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.passwordsEntries.data.length,
                        itemBuilder: (context, index) {
                          return PasswordEntryTile(
                            passwordEntryModel:
                                state.passwordsEntries.data[index],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
