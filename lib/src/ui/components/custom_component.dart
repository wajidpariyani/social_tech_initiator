import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isPrimary
        ? ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    )
        : TextButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
