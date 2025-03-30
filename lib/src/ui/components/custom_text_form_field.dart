import 'package:flutter/material.dart';
import 'package:social_tech_initiator/src/ui/components/dialog_components.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextInputAction textInputAction;
  final VoidCallback? onEditingComplete;
  final Function(String)? onChanged;
  final List<String> infoMessages;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;

  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.label,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.textInputAction = TextInputAction.done,
    this.onEditingComplete,
    this.onChanged,
    required this.infoMessages,
    this.focusNode,
    this.nextFocusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textInputAction: textInputAction,
      focusNode: focusNode,
      onEditingComplete: onEditingComplete ??
              () {
            if (textInputAction == TextInputAction.done) {
              FocusScope.of(context).unfocus();
            } else if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            }
          },
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding:
        const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        suffixIcon: infoMessages.isNotEmpty
            ? GestureDetector(
          onTap: () {
            showAlertDialog(
              context,
              'Field Validation Info',
              SingleChildScrollView(
                child: ListBody(
                  children:
                  infoMessages.map((message) => Text(message)).toList(),
                ),
              ),
              [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
          child: Icon(Icons.info_outline, size: 20),
        )
            : null,
      ),
    );
  }
}
