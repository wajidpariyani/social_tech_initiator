import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

extension Spacing on num {
  Widget get h => SizedBox(width: toDouble());

  Widget get v => SizedBox(height: toDouble());

  Widget get blank => SizedBox(height: 0);
}

flutterPrint(String message) {
  if (kDebugMode) print(message);
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

pageMargin() {
  return EdgeInsets.symmetric(horizontal: 16, vertical: 16);
}
