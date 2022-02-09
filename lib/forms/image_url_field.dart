import 'package:flutter/material.dart';

class ImageUrlField extends StatefulWidget {
  final TextEditingController imageUrlController;
  final FocusNode focusNode;
  final Function saveForm;
  final Function onSaved;

  const ImageUrlField({
    @required this.imageUrlController,
    @required this.onSaved,
    this.focusNode = null,
    this.saveForm = null,
  });

  @override
  State<ImageUrlField> createState() => _ImageUrlFieldState();
}

class _ImageUrlFieldState extends State<ImageUrlField> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          alignment: Alignment.center,
          width: 100,
          height: 100,
          margin: const EdgeInsets.only(top: 8, right: 10),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          child: widget.imageUrlController.text.isEmpty
              ? Icon(
                  Icons.image_search,
                  size: 50,
                )
              : ClipRRect(
                  child: FittedBox(
                    child: Image.network(widget.imageUrlController.text),
                    fit: BoxFit.cover,
                  ),
                ),
        ),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(labelText: 'Image URL'),
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.done,
            controller: widget.imageUrlController,
            focusNode: widget.focusNode,
            onFieldSubmitted: (_) {
              if (widget.saveForm != null) {
                widget.saveForm();
              }
            },
            onEditingComplete: () {
              setState(() {});
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter image URL.';
              } else if (!value.startsWith('http') &&
                  !value.startsWith('https')) {
                return 'Please enter a valid URL.';
              }
              return null;
            },
            onSaved: widget.onSaved,
          ),
        ),
      ],
    );
  }
}
