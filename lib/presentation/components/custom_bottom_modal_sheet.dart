import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/constants.dart';
import 'package:custos/presentation/components/custom_close_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Build a custom bottom modal sheet base widget
class CustomBottomModalSheet extends StatefulWidget {
  const CustomBottomModalSheet({
    super.key,
    required this.heightFactor,
    this.title,
    this.showScrollBar = false,
    required this.child,
  });

  final double? heightFactor;
  final String? title;
  final bool showScrollBar;
  final Widget child;

  @override
  State<CustomBottomModalSheet> createState() => _CustomBottomModalSheetState();
}

class _CustomBottomModalSheetState extends State<CustomBottomModalSheet> {
  ScrollController? controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: MediaQuery.of(context).viewInsets,
      constraints:
          widget.heightFactor != null
              ? BoxConstraints(
                maxHeight:
                    MediaQuery.of(context).size.height * widget.heightFactor!,
              )
              : null,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(kMobileCornerX8),
          topRight: Radius.circular(kMobileCornerX8),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: [
              const SizedBox(width: 46.0),
              const Spacer(),
              Container(
                width: 64.0,
                height: 4,
                decoration: const ShapeDecoration(
                  shape: StadiumBorder(),
                  color: Colors.grey,
                ),
              ),
              const Spacer(),
              CustomCloseButton(
                onTap: () {
                  context.pop();
                },
              ),
              const SizedBox(width: 26.0),
            ],
          ),
          if (widget.title != null) ...[
            const SizedBox(height: 18.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.0),
              child: Text(widget.title!, style: context.textTheme.titleMedium),
            ),
          ],
          Flexible(
            child:
                widget.showScrollBar
                    ? Scrollbar(
                      thumbVisibility: widget.showScrollBar,
                      controller: controller,
                      child: drawChild,
                    )
                    : drawChild,
          ),
        ],
      ),
    );
  }

  Widget get drawChild => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: SingleChildScrollView(
      controller: controller,
      child: Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: widget.child,
      ),
    ),
  );
}
