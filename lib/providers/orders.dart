import 'package:flutter/foundation.dart';

import 'item_in_order.dart';
import '../models/item_in_cart.dart';

class Orders with ChangeNotifier {
  List<ItemInOrder> _orders = [];

  List<ItemInOrder> get orders {
    return [..._orders];
  }

  int get length {
    return _orders.length;
  }

  void addOrder(List<ItemInCart> cartProducts, double total) {
    _orders.insert(
      0,
      ItemInOrder(
        id: DateTime.now().toString(),
        amount: total,
        itemsInCart: cartProducts,
        dateTime: DateTime.now(),
      ),
    ); // Add to front
    notifyListeners();
  }

  void minimiseOrders() {
    _orders.forEach((order) {
      order.minimise_order();
    });
  }
}
