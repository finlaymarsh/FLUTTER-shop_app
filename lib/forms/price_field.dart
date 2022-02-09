import 'package:flutter/material.dart';

class PriceField extends StatelessWidget {
  final String initialValue;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;
  final Function onSaved;

  const PriceField({
    @required this.initialValue,
    @required this.focusNode,
    @required this.nextFocusNode,
    @required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue == "0.00" ? "" : initialValue,
      decoration: InputDecoration(labelText: 'Price', prefixText: '£'),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      focusNode: focusNode,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(nextFocusNode);
      },
      validator: (value) {
        if (value.isEmpty) {
          return "Please enter a price.";
        } else if (double.tryParse(value) == null) {
          return "Please enter a valid number.";
        } else if (double.parse(value) <= 0) {
          return "Please enter a price greater than £0.00";
        }
        return null;
      },
      onSaved: onSaved,
    );
  }
}

/*
onSaved: (value) {
  _editedProduct = Product(
      title: _editedProduct.title,
      price: double.parse(value),
      description: _editedProduct.description,
      imageUrl: _editedProduct.imageUrl,
      id: null);
},
*/