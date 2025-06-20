import 'package:custos/core/utils/base_state/base_state.dart';
import 'package:custos/presentation/components/custom_circular_progress_indicator.dart';
import 'package:custos/presentation/components/failure_widget.dart';
import 'package:flutter/material.dart';

/// This widget create the base isLoading, isError, isEmpty or isData to build the corrects
/// widgets in the UI.
class BaseStateUi<T> extends StatelessWidget {
  const BaseStateUi({
    super.key,
    required this.state,
    required this.onRetryPressed,
    required this.onDataChild,
    this.noDataWidget,
    this.extendedHeight,
    this.remainLoading = false,
    this.secondLoading = false,
    this.secondLoadingPadding,
    this.secondLoadingColor,
  });

  /// The current state of the UI (loading, error, empty, data).
  final BaseState<T> state;

  /// Callback function triggered when retry is pressed (used in error or empty states).
  final Function() onRetryPressed;

  /// Function that builds the widget using the data when state is "data".
  final Widget Function(T data) onDataChild;

  /// NoData widget to display when there is no data.
  final Widget? noDataWidget;

  /// Optional height to apply when the loading indicator is shown.
  final double? extendedHeight;

  /// If true, keeps showing the loading indicator even if state is not loading.
  final bool remainLoading;

  /// If true, shows a smaller loading indicator while data is being refreshed or loaded in the background.
  final bool secondLoading;

  /// Optional padding around the second loading indicator.
  final EdgeInsetsGeometry? secondLoadingPadding;

  /// Optional color for the second loading indicator.
  final Color? secondLoadingColor;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading || remainLoading) {
      return SizedBox(
        height: extendedHeight,
        child: Center(child: CustomCircularProgressIndicator()),
      );
    } else if (state.isError) {
      return SizedBox(
        height: extendedHeight,
        child: Center(
          child: FailureWidget(
            failure: state.error,
            onRetryPressed: onRetryPressed,
          ),
        ),
      );
    } else if (state.isEmpty) {
      return SizedBox(
        height: extendedHeight,
        child: Center(child: noDataWidget),
      );
    } else if (state.isData) {
      if (secondLoading) {
        return Column(
          children: [
            Padding(
              padding: secondLoadingPadding ?? EdgeInsets.zero,
              child: CustomCircularProgressIndicator(
                dimension: 20.0,
                strokeWidth: 2.0,
                color: secondLoadingColor,
              ),
            ),
            Expanded(child: onDataChild(state.data)),
          ],
        );
      } else {
        return onDataChild(state.data);
      }
    } else {
      return const SizedBox.shrink();
    }
  }
}
