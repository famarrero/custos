import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/color_scheme_extension.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:custos/data/models/password_entry/password_entry_entity.dart';
import 'package:custos/data/models/password_strength_groug/password_strength_group_entity.dart';
import 'package:custos/presentation/pages/analytics/components/legend_item.dart';
import 'package:custos/presentation/pages/analytics/components/password_modal_content.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Índice de sección: 0 = Fuerte, 1 = Media, 2 = Débil.
const int _indexStrong = 0;
const int _indexMedium = 1;
const int _indexWeak = 2;

/// Gráfico tipo donut con totales por sección, efecto al tocar y modal con entradas.
class PasswordStrengthChart extends StatefulWidget {
  const PasswordStrengthChart({super.key, required this.strengthGroup});

  final PasswordStrengthGroupEntity strengthGroup;

  @override
  State<PasswordStrengthChart> createState() => _PasswordStrengthChartState();
}

class _PasswordStrengthChartState extends State<PasswordStrengthChart> {
  int touchedIndex = -1;

  int get _total =>
      widget.strengthGroup.weak.length + widget.strengthGroup.medium.length + widget.strengthGroup.strong.length;

  int get _securityScore {
    if (_total == 0) return 0;
    final s = widget.strengthGroup.strong.length * 100;
    final m = widget.strengthGroup.medium.length * 50;
    return ((s + m) / _total).round().clamp(0, 100);
  }

  /// Orden de categorías que se muestran en el gráfico (solo las con count > 0).
  List<int> _getCategoryIndices() {
    final weakCount = widget.strengthGroup.weak.length;
    final mediumCount = widget.strengthGroup.medium.length;
    final strongCount = widget.strengthGroup.strong.length;
    final indices = <int>[];
    if (strongCount > 0) indices.add(_indexStrong);
    if (mediumCount > 0) indices.add(_indexMedium);
    if (weakCount > 0) indices.add(_indexWeak);
    return indices;
  }

  List<PieChartSectionData> _showingSections() {
    final theme = Theme.of(context);
    final weakCount = widget.strengthGroup.weak.length;
    final mediumCount = widget.strengthGroup.medium.length;
    final strongCount = widget.strengthGroup.strong.length;

    double radius(int i) => i == touchedIndex ? 58.0 : 50.0;
    double fontSize(int i) => (i == touchedIndex ? 18.0 : 14.0).toDouble();
    final textColor = Colors.white;
    const shadows = [Shadow(color: Colors.black26, blurRadius: 2)];

    final total = weakCount + mediumCount + strongCount;
    if (total == 0) return [];

    final sections = <PieChartSectionData>[];
    int sectionIndex = 0;

    if (strongCount > 0) {
      final pct = (strongCount / total * 100).round();
      sections.add(
        PieChartSectionData(
          color: theme.colorScheme.passwordStrengthStrong,
          value: strongCount.toDouble(),
          title: '$pct%',
          radius: radius(sectionIndex),
          titleStyle: TextStyle(
            fontSize: fontSize(sectionIndex),
            fontWeight: FontWeight.bold,
            color: textColor,
            shadows: shadows,
          ),
        ),
      );
      sectionIndex++;
    }
    if (mediumCount > 0) {
      final pct = (mediumCount / total * 100).round();
      sections.add(
        PieChartSectionData(
          color: theme.colorScheme.passwordStrengthMedium,
          value: mediumCount.toDouble(),
          title: '$pct%',
          radius: radius(sectionIndex),
          titleStyle: TextStyle(
            fontSize: fontSize(sectionIndex),
            fontWeight: FontWeight.bold,
            color: textColor,
            shadows: shadows,
          ),
        ),
      );
      sectionIndex++;
    }
    if (weakCount > 0) {
      final pct = (weakCount / total * 100).round();
      sections.add(
        PieChartSectionData(
          color: theme.colorScheme.passwordStrengthWeak,
          value: weakCount.toDouble(),
          title: '$pct%',
          radius: radius(sectionIndex),
          titleStyle: TextStyle(
            fontSize: fontSize(sectionIndex),
            fontWeight: FontWeight.bold,
            color: textColor,
            shadows: shadows,
          ),
        ),
      );
    }

    return sections;
  }

  void _onTapUp() {
    if (touchedIndex < 0) return;
    final categoryIndices = _getCategoryIndices();
    if (touchedIndex >= categoryIndices.length) {
      setState(() => touchedIndex = -1);
      return;
    }
    final categoryIndex = categoryIndices[touchedIndex];
    setState(() => touchedIndex = -1);
    _showPasswordsModal(categoryIndex);
  }

  void _showPasswordsModal(int sectionIndex) {
    final List<PasswordEntryEntity> entries;
    final String title;
    final Color color;
    switch (sectionIndex) {
      case _indexStrong:
        entries = widget.strengthGroup.strong;
        title = 'Contraseñas fuertes';
        color = context.colorScheme.passwordStrengthStrong;
        break;
      case _indexMedium:
        entries = widget.strengthGroup.medium;
        title = 'Contraseñas medias';
        color = context.colorScheme.passwordStrengthMedium;
        break;
      case _indexWeak:
        entries = widget.strengthGroup.weak;
        title = 'Contraseñas débiles';
        color = context.colorScheme.passwordStrengthWeak;
        break;
      default:
        return;
    }

    context.showCustomModalBottomSheet<void>(
      title: title,
      heightFactor: 0.5,
      child: PasswordsModalContent(entries: entries, color: color, subtitle: '${entries.length} entradas'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sections = _total > 0 ? _showingSections() : _emptySections(theme);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 240,
          child: Listener(
            onPointerUp: (_) => _onTapUp(),
            child: Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 1.5,
                      centerSpaceRadius: 56,
                      sections: sections,
                    ),
                    duration: const Duration(milliseconds: 300),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$_securityScore',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Puntuación',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: context.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LegendItem(color: context.colorScheme.passwordStrengthStrong, label: 'Fuerte'),
            SizedBox(width: context.lg),
            LegendItem(color: context.colorScheme.passwordStrengthMedium, label: 'Media'),
            SizedBox(width: context.lg),
            LegendItem(color: context.colorScheme.passwordStrengthWeak, label: 'Débil'),
          ],
        ),
      ],
    );
  }

  List<PieChartSectionData> _emptySections(ThemeData theme) {
    final c = theme.colorScheme.outlineVariant;
    return [
      PieChartSectionData(
        value: 1,
        color: c,
        title: '0%',
        radius: 50,
        titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
      ),
      PieChartSectionData(
        value: 1,
        color: c,
        title: '0%',
        radius: 50,
        titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
      ),
      PieChartSectionData(
        value: 1,
        color: c,
        title: '0%',
        radius: 50,
        titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
      ),
    ];
  }
}
