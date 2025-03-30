import 'package:flutter/material.dart';

class CommonScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final PreferredSizeWidget? appBar;

  const CommonScaffold({
    Key? key,
    required this.title,
    required this.body,
    this.actions,
    this.appBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ?? AppBar(
        title: Text(title),
        actions: actions,
      ),
      body: body,
    );
  }
}
