import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/app_spacing.dart';
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
      padding: EdgeInsets.symmetric(vertical: context.xl),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(context.corner() * 2),
          topRight: Radius.circular(context.corner() * 2),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: [
              SizedBox(width: context.space(11.5)),
              const Spacer(),
              Container(
                width: context.space(16),
                height: context.s,
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
              SizedBox(width: context.space(6.5)),
            ],
          ),
          if (widget.title != null) ...[
            SizedBox(height: context.space(4.5)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.space(6.5)),
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
    padding: EdgeInsets.symmetric(horizontal: context.xxl),
    child: SingleChildScrollView(
      controller: controller,
      child: Padding(
        padding: EdgeInsets.only(top: context.xxxl),
        child: widget.child,
      ),
    ),
  );
}
