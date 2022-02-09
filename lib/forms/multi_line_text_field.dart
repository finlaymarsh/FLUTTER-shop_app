import 'package:flutter/material.dart';

class MultiLineTextField extends StatelessWidget {
  final String label;
  final String initialValue;
  final Function onSaved;
  final FocusNode focusNode;
  final int maxLines;

  const MultiLineTextField({
    @required this.label,
    @required this.initialValue,
    @required this.onSaved,
    this.focusNode = null,
    this.maxLines = 3,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: maxLines,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(labelText: label),
      focusNode: focusNode,
      validator: (value) {
        if (value.isEmpty) {
          return "Please provide a ${label.toLowerCase()}.";
        } else if (value.length < 10) {
          return "Should be at least 10 characters long.";
        }
        return null;
      },
      onSaved: onSaved,
    );
  }
}
