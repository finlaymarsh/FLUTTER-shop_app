import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';
import '../forms/single_line_text_field.dart';
import '../forms/multi_line_text_field.dart';
import '../forms/price_field.dart';
import '../forms/image_url_field.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _title = "";
  var _price = 0.0;
  var _description = "";
  var _imageUrl = "";
  var _isInit = true;
  var _loadedProduct = null;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final product = ModalRoute.of(context).settings.arguments as Product;
      if (product != null) {
        _title = product.title;
        _price = product.price;
        _description = product.description;
        _imageUrl = product.imageUrl;
        _imageUrlController.text = product.imageUrl;
        _loadedProduct = product;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() async {
    if (_form.currentState.validate()) {
      _form.currentState.save();
      setState(() {
        _isLoading = true;
      });
      if (_loadedProduct == null) {
        try {
          await Provider.of<Products>(context, listen: false).addProduct(
            Product(
              id: DateTime.now().toString(),
              title: _title,
              price: _price,
              description: _description,
              imageUrl: _imageUrl,
            ),
          );
        } catch (error) {
          await showDialog<Null>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('An error occurred!'),
              content: Text(
                'Something went wrong.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Okay'),
                ),
              ],
            ),
          );
        }
      } else {
        await Provider.of<Products>(context, listen: false).updateProduct(
          Product(
            id: _loadedProduct.id,
            title: _title,
            price: _price,
            description: _description,
            imageUrl: _imageUrl,
            isFavourite: _loadedProduct.isFavourite,
          ),
        );
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.save,
        ),
        onPressed: _saveForm,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
                    child: Column(
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleLineTextField(
                              initialText: _title,
                              label: "Title",
                              nextFocusNode: _priceFocusNode,
                              onSaved: (value) => _title = value,
                            ),
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: PriceField(
                              initialValue: _price.toStringAsFixed(2),
                              focusNode: _priceFocusNode,
                              nextFocusNode: _descriptionFocusNode,
                              onSaved: (value) => _price = double.parse(value),
                            ),
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MultiLineTextField(
                              initialValue: _description,
                              label: 'Description',
                              onSaved: (value) => _description = value,
                            ),
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ImageUrlField(
                              imageUrlController: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              saveForm: _saveForm,
                              onSaved: (value) => _imageUrl = value,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
