import 'package:flutter/foundation.dart';

import '../providers/product.dart';
import '../models/item_in_cart.dart';

class Cart with ChangeNotifier {
  Map<String, ItemInCart> _items = {};

  Map<String, ItemInCart> get items {
    return {..._items};
  }

  int get sizeOfCart {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.product.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingCartItem) => ItemInCart(
          id: existingCartItem.id,
          product: existingCartItem.product,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => ItemInCart(
          id: DateTime.now().toString(),
          product: product,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(Product product) {
    _items.remove(product.id);
    notifyListeners();
  }

  void removeSingleItem(Product product) {
    if (!_items.containsKey(product.id)) {
      return;
    }
    if (_items[product.id].quantity > 1) {
      _items.update(
        product.id,
        (existingCartItem) => ItemInCart(
          id: existingCartItem.id,
          product: existingCartItem.product,
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(product.id);
      notifyListeners();
    }
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
