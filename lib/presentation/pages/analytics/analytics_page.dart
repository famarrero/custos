import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:custos/data/models/password_entry/password_entry_entity.dart';
import 'package:custos/data/models/repeated_password_group/repeated_password_group_entity.dart';
import 'package:custos/presentation/components/base_state_ui.dart';
import 'package:custos/presentation/components/no_data_widget.dart';
import 'package:custos/presentation/components/scaffold_widget.dart';
import 'package:custos/presentation/pages/analytics/components/analytics_card.dart';
import 'package:custos/presentation/pages/analytics/cubit/analytics_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AnalyticsCubit()
        ..getRepetitivePasswordsGroups()
        ..getPasswordsByStrength(),
      child: ScaffoldWidget(
        padding: EdgeInsets.symmetric(horizontal: context.xl),
        child: BlocBuilder<AnalyticsCubit, AnalyticsState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: context.lg),
                  // Contraseñas repetidas
                  BaseStateUi<List<RepeatedPasswordGroupEntity>>(
                    state: state.repetitivePasswordsGroups,
                    onRetryPressed: () => context.read<AnalyticsCubit>().getRepetitivePasswordsGroups(),
                    noDataWidget: NoDataWidget(
                      iconData: null,
                      title: 'No hay contraseñas repetidas',
                    ),
                    onDataChild: (groups) {
                      final allEntries = <PasswordEntryEntity>[];
                      for (final group in groups) {
                        allEntries.addAll(group.passwordsEntries);
                      }
                      
                      if (allEntries.isEmpty) {
                        return NoDataWidget(
                          iconData: null,
                          title: 'No hay contraseñas repetidas',
                        );
                      }
                      
                      return AnalyticsCard(
                        title: 'Contraseñas repetidas',
                        passwordEntries: allEntries,
                      );
                    },
                  ),
                  // Contraseñas por fortaleza
                  BaseStateUi(
                    state: state.passwordsByStrength,
                    onRetryPressed: () => context.read<AnalyticsCubit>().getPasswordsByStrength(),
                    noDataWidget: NoDataWidget(
                      iconData: null,
                      title: 'No hay datos de fortaleza',
                    ),
                    onDataChild: (strengthGroup) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (strengthGroup.weak.isNotEmpty)
                            AnalyticsCard(
                              title: 'Contraseñas débiles',
                              passwordEntries: strengthGroup.weak,
                            ),
                          if (strengthGroup.medium.isNotEmpty)
                            AnalyticsCard(
                              title: 'Contraseñas medianas',
                              passwordEntries: strengthGroup.medium,
                            ),
                          if (strengthGroup.strong.isNotEmpty)
                            AnalyticsCard(
                              title: 'Contraseñas fuertes',
                              passwordEntries: strengthGroup.strong,
                            ),
                          if (strengthGroup.weak.isEmpty &&
                              strengthGroup.medium.isEmpty &&
                              strengthGroup.strong.isEmpty)
                            NoDataWidget(
                              iconData: null,
                              title: 'No hay datos de fortaleza',
                            ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: context.lg),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
