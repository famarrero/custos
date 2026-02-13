import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/color_scheme_extension.dart';
import 'package:custos/core/utils/app_icons.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:custos/data/models/password_entry/password_entry_entity.dart';
import 'package:custos/data/models/repeated_password_group/repeated_password_group_entity.dart';
import 'package:custos/presentation/components/base_state_ui.dart';
import 'package:custos/presentation/components/custom_button.dart';
import 'package:custos/presentation/components/no_data_widget.dart';
import 'package:custos/presentation/components/scaffold_widget.dart';
import 'package:custos/presentation/pages/analytics/components/critical_issues_tile.dart';
import 'package:custos/presentation/pages/analytics/components/password_modal_content.dart';
import 'package:custos/presentation/pages/analytics/components/password_strength_chart.dart';
import 'package:custos/presentation/pages/analytics/cubit/analytics_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AnalyticsCubit()..startAnalysis(),
      child: ScaffoldWidget(
        padding: EdgeInsets.symmetric(horizontal: context.xl),
        child: BlocBuilder<AnalyticsCubit, AnalyticsState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: context.lg),
                        // Contraseñas por fortaleza
                        BaseStateUi(
                          state: state.passwordsByStrength,
                          onRetryPressed: () => context.read<AnalyticsCubit>().getPasswordsByStrength(),
                          onDataChild: (strengthGroup) {
                            return PasswordStrengthChart(strengthGroup: strengthGroup);
                          },
                        ),

                        SizedBox(height: context.xxl),

                        if (state.repetitivePasswordsGroups.isData || state.olderPasswordsEntries.isData)
                          Text('Critical issues', style: context.textTheme.titleMedium),

                        SizedBox(height: context.lg),

                        if (!state.repetitivePasswordsGroups.isData && !state.olderPasswordsEntries.isData) ...[
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: context.xxxl),
                            child: NoDataWidget(
                              iconData: AppIcons.analytics,
                              title: 'No hay criticles issues',
                              subtitle: 'Esta todo muy bien por aca, tu seguridad esta garantizada. Sigue asi.',
                            ),
                          ),
                        ],

                        // Contraseñas repetidas
                        BaseStateUi<List<RepeatedPasswordGroupEntity>>(
                          state: state.repetitivePasswordsGroups,
                          onRetryPressed: () => context.read<AnalyticsCubit>().getRepetitivePasswordsGroups(),
                          onDataChild: (groups) {
                            return CriticalIssueTile(
                              title: 'Contraseñas repetidas',
                              subtitle: '${groups.length} grupo de contraseñas repetidas',
                              icon: Icons.warning,
                              color: context.colorScheme.error,
                              onTap: () {
                                final entries = groups.expand((group) => group.passwordsEntries).toList();
                                context.showCustomModalBottomSheet(
                                  title: 'Contraseñas repetidas',
                                  child: PasswordsModalContent(
                                    entries: entries,
                                    color: context.colorScheme.error,
                                    subtitle: '${entries.length} contraseñas repetidas',
                                    info:
                                        'Utilice contraseñas únicas para cada sitio web o aplicación. Si alguien descubre una contraseña, puede acceder a todos los sitios web o aplicaciones que la utilicen.',
                                  ),
                                );
                              },
                            );
                          },
                        ),

                        SizedBox(height: context.lg),

                        BaseStateUi<List<PasswordEntryEntity>>(
                          state: state.olderPasswordsEntries,
                          onRetryPressed: () => context.read<AnalyticsCubit>().getOlderPasswordsEntries(),
                          onDataChild: (olderPasswordsEntries) {
                            return CriticalIssueTile(
                              title: 'Contraseñas antiguas',
                              subtitle: '${olderPasswordsEntries.length} contraseñas con mas de 6 meses',
                              icon: Icons.access_time,
                              color: context.colorScheme.waring,
                              onTap: () {
                                context.showCustomModalBottomSheet(
                                  title: 'Contraseñas antiguas',
                                  child: PasswordsModalContent(
                                    entries: olderPasswordsEntries,
                                    color: context.colorScheme.error,
                                    subtitle: '${olderPasswordsEntries.length} contraseñas antiguas',
                                    info:
                                        'Contraseñas muy antiguas son mas susceptibles a ser comprometidas. Recomendamos cambiarlas cada cierto tiempo.',
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: context.xxl),

                Align(
                  child: CustomButton(
                    label: 'Analizar seguridad',
                    onPressed: () {
                      context.read<AnalyticsCubit>().startAnalysis();
                    },
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
