import 'package:custos/presentation/components/scaffold_widget.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      safeAreaTop: true,
      appBar: AppBar(
        title: Text('Passwords'),
        centerTitle: true,
        actions: [Icon(Icons.add)],
        actionsPadding: EdgeInsets.all(14.0),
      ),
      child: child,
    );
  }
}
