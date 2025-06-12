import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomCircularProgressIndicator extends StatelessWidget {
  CustomCircularProgressIndicator({
    this.color,
    this.strokeWidth,
    this.dimension,
    super.key,
  });

  final Color? color;
  late double? dimension;
  late double? strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.square(
        dimension: dimension ?? 42.0,
        child: CircularProgressIndicator(
          color: color ?? context.colorScheme.primary,
          strokeWidth: strokeWidth ?? 4.0,
        ),
      ),
    );
  }
}
