import 'package:flutter/material.dart';

class SingleLineTextField extends StatelessWidget {
  final String label;
  final String initialText;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;
  final Function onSaved;

  const SingleLineTextField({
    @required this.label,
    @required this.initialText,
    @required this.onSaved,
    this.focusNode = null,
    this.nextFocusNode = null,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialText,
      decoration: InputDecoration(
        labelText: label,
      ),
      textInputAction:
          nextFocusNode != null ? TextInputAction.next : TextInputAction.done,
      focusNode: focusNode,
      onFieldSubmitted: (_) {
        if (nextFocusNode != null) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        }
      },
      validator: (value) {
        if (value.isEmpty) {
          return "Please provide a ${label.toLowerCase()}.";
        }
        return null;
      },
      onSaved: onSaved,
    );
  }
}
