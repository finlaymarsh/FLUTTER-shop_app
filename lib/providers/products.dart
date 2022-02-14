import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import 'product.dart';

class Products with ChangeNotifier {
  static const baseUrl =
      'https://shopping-cart-91ceb-default-rtdb.europe-west1.firebasedatabase.app/';
  static const _pathToProducts = '/products';
  String _trailingUrl;

  final String authToken;
  final String userId;
  List<Product> _items;

  Products(this.authToken, this.userId, this._items) {
    _trailingUrl = '.json?auth=${authToken}';
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((product) => product.isFavourite).toList();
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse('${baseUrl}${_pathToProducts}${_trailingUrl}');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorId': userId,
          },
        ),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser == true ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    final url =
        Uri.parse('${baseUrl}${_pathToProducts}${_trailingUrl}${filterString}');
    final favouriteUrl = Uri.parse(
        '${baseUrl}${Product.pathToFavourites}/${userId}$_trailingUrl');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> retrieved_items = [];
      if (extractedData == null) {
        return;
      }
      final favouriteResponse = await http.get(favouriteUrl);
      final favouriteData = json.decode(favouriteResponse.body);
      extractedData.forEach((id, productData) {
        retrieved_items.add(
          Product(
            id: id,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            imageUrl: productData['imageUrl'],
            isFavourite:
                favouriteData == null ? false : favouriteData[id] ?? false,
          ),
        );
      });
      _items = retrieved_items;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> updateProduct(Product product) async {
    final url =
        Uri.parse('${baseUrl}${_pathToProducts}/${product.id}${_trailingUrl}');
    await http.patch(
      url,
      body: json.encode(
        {
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
        },
      ),
    );
    final prodIndex = _items.indexWhere((prod) => prod.id == product.id);
    _items[prodIndex] = product;
    notifyListeners();
  }

  void deleteProduct(Product product) async {
    final url =
        Uri.parse('${baseUrl}${_pathToProducts}/${product.id}${_trailingUrl}');
    final existingProductIndex =
        _items.indexWhere((prod) => prod.id == product.id);
    final existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
  }

  Product findById(String id) {
    try {
      return _items.firstWhere((prod) => prod.id == id);
    } catch (error) {
      throw error;
    }
  }
}
