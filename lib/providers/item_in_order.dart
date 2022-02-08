import 'package:flutter/foundation.dart';

import '../models/item_in_cart.dart';

class ItemInOrder with ChangeNotifier {
  final String id;
  final double amount;
  final List<ItemInCart> itemsInCart;
  final DateTime dateTime;
  var expanded = false;

  ItemInOrder({
    @required this.id,
    @required this.amount,
    @required this.itemsInCart,
    @required this.dateTime,
  });

  int get numberOfProducts {
    return itemsInCart.length;
  }

  void expand_order() {
    expanded = true;
    notifyListeners();
  }

  void minimise_order() {
    expanded = false;
    notifyListeners();
  }
}
