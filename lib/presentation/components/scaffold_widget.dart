import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';

/// A widget used to wrap pages of the app with the appropriate [appBar] and [bottomBar].
/// Also, it adds the appropriate insets to the [child].
class ScaffoldWidget extends StatefulWidget {
  const ScaffoldWidget({
    super.key,
    this.scaffoldKey,
    required this.child,
    this.safeAreaTop = false,
    this.appBar,
    this.drawer,
    this.endDrawer,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.padding,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
  });

  final Key? scaffoldKey;

  /// Whether to avoid system intrusions at the top of the screen, typically the system status bar.
  final bool safeAreaTop;

  /// If true, and [bottomNavigationBar] or [persistentFooterButtons] is specified,
  /// then the [body] extends to the bottom of the Scaffold, instead of only extending to the top of the [bottomNavigationBar] or the [persistentFooterButtons].
  final bool extendBody;

  /// If true, and an [appBar] is specified, then the height of the [body] is
  /// extended to include the height of the app bar and the top of the body is aligned with the top of the app bar.
  final bool extendBodyBehindAppBar;

  /// The top bar of the page.
  /// if set an appBar set the [showDefaultAppBar] property to false
  final PreferredSizeWidget? appBar;

  /// Floating action button
  final Widget? floatingActionButton;

  /// Floating action button location
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// The bottom bar of the page.
  final Widget? bottomNavigationBar;

  final EdgeInsetsGeometry? padding;

  final Widget? drawer;

  final Widget? endDrawer;

  /// The widget that will be shown by this widget.
  final Widget child;

  @override
  State<ScaffoldWidget> createState() => _ScaffoldWidgetState();
}

class _ScaffoldWidgetState extends State<ScaffoldWidget> {
  bool showBottomBar = true;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.colorScheme.primary,
      child: SafeArea(
        top: widget.safeAreaTop,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.opaque,
          child: Scaffold(
            key: widget.scaffoldKey,
            drawer: widget.drawer,
            endDrawer: widget.endDrawer,
            extendBody: widget.extendBody,
            extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
            appBar: widget.appBar,
            floatingActionButton: widget.floatingActionButton,
            floatingActionButtonLocation: widget.floatingActionButtonLocation,
            bottomNavigationBar:
                showBottomBar
                    ? widget.bottomNavigationBar
                    : const SizedBox.shrink(),
            body: Padding(
              padding: widget.padding ?? EdgeInsets.zero,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
