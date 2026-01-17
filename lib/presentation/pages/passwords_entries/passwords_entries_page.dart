import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:custos/presentation/components/base_state_ui.dart';
import 'package:custos/presentation/components/biometric_setup_dialog/biometric_setup_dialog.dart';
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
import 'package:custos/core/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PasswordsEntriesPage extends StatefulWidget {
  const PasswordsEntriesPage({super.key});

  @override
  State<PasswordsEntriesPage> createState() => _PasswordsEntriesPageState();
}

class _PasswordsEntriesPageState extends State<PasswordsEntriesPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _hasShownBiometricDialog = false;

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
          context.read<PasswordsEntriesCubit>().watchGroups();

          // Mostrar diálogo de configuración biométrica después del primer login
          // Solo si el perfil no tiene biométrica habilitada y aún no se ha mostrado el diálogo
          if (state.loginState.isData &&
              !state.loginState.data.hasBiometricEnabled &&
              !_hasShownBiometricDialog) {
            _hasShownBiometricDialog = true;
            // Usar un pequeño delay para que la página se cargue primero
            Future.delayed(const Duration(milliseconds: 500), () {
              if (context.mounted) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => BiometricSetupDialog(
                    profile: state.loginState.data,
                  ),
                );
              }
            });
          }
        },
        child: ScaffoldWidget(
          floatingActionButton: FloatingActionButton(
            child: Icon(AppIcons.add, color: Colors.white),
            onPressed: () {
              context.push(
                UpsertPasswordEntryRoute(
                  id: UpsertPasswordEntryCubit.addUserId,
                ).location,
              );
            },
          ),
          child: BlocBuilder<PasswordsEntriesCubit, PasswordsEntriesState>(
            builder: (context, state) {
              return Column(
                children: [
                  Expanded(
                    child: BaseStateUi(
                      state: state.passwordsEntries,
                      onRetryPressed:
                          () =>
                              context
                                  .read<PasswordsEntriesCubit>()
                                  .watchPasswordsEntries(),
                      noDataWidget: NoDataWidget(
                        iconData: AppIcons.key,
                        title: context.l10n.passwordsNoPasswordsTitle,
                        subtitle: context.l10n.passwordsNoPasswordsSubtitle,
                      ),
                      onDataChild: (passwordsEntries) {
                        return Column(
                          children: [
                            // Search form
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.xl,
                              ),
                              child: ValueListenableBuilder<TextEditingValue>(
                                valueListenable: _searchController,
                                builder: (context, value, _) {
                                  final hasQuery = value.text.trim().isNotEmpty;

                                  return CustomTextFormField(
                                    controller: _searchController,
                                    hint: context.l10n.passwordsSearchHint,
                                    boxShadow: context.searchBarShadow,
                                    prefixIcon: Icon(
                                      AppIcons.search,
                                      color: context.colorScheme.primary,
                                    ),
                                    suffixIcon:
                                        hasQuery
                                            ? CustomIconButton(
                                              icon: AppIcons.close,
                                              iconColor:
                                                  context.colorScheme.primary,
                                              onTap: () {
                                                context
                                                    .read<
                                                      PasswordsEntriesCubit
                                                    >()
                                                    .filterPasswordEntries(
                                                      query: null,
                                                      group:
                                                          state.selectedGroup,
                                                    );
                                                _searchController.clear();
                                              },
                                            )
                                            : null,
                                    onChanged: (value) {
                                      context
                                          .read<PasswordsEntriesCubit>()
                                          .filterPasswordEntries(
                                            query: value,
                                            group: state.selectedGroup,
                                          );
                                    },
                                  );
                                },
                              ),
                            ),

                            SizedBox(height: context.xxxl),

                            GroupFilters(),

                            SizedBox(height: context.s),

                            if (passwordsEntries.isEmpty)
                              Expanded(
                                child: NoDataWidget(
                                  subtitle:
                                      context.l10n.passwordsNoResultsSubtitle,
                                  retryLabel:
                                      context.l10n.passwordsCleanFilters,
                                  onRetryPressed: () {
                                    context
                                        .read<PasswordsEntriesCubit>()
                                        .filterPasswordEntries(
                                          group: PasswordsEntriesCubit.groupAll,
                                        );

                                    _searchController.clear();
                                  },
                                ),
                              )
                            else
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: context.xl,
                                      left: context.xl,
                                      right: context.xl,
                                    ),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: passwordsEntries.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: context.s,
                                          ),
                                          child: PasswordEntryTile(
                                            passwordEntry:
                                                passwordsEntries[index],
                                          ),
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
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
