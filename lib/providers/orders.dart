import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'item_in_order.dart';
import '../models/item_in_cart.dart';

class Orders with ChangeNotifier {
  static const baseUrl =
      'https://shopping-cart-91ceb-default-rtdb.europe-west1.firebasedatabase.app/';
  static const _pathToOrders = '/orders';
  List<ItemInOrder> _orders = [];

  List<ItemInOrder> get orders {
    return [..._orders];
  }

  int get length {
    return _orders.length;
  }

  Future<void> addOrder(List<ItemInCart> cartProducts, double total) async {
    final url = Uri.parse('${baseUrl}${_pathToOrders}.json');
    final timeStamp = DateTime.now();
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'amount': total,
            'itemsInCart': cartProducts
                .map(
                  (cp) => {
                    'id': cp.id,
                    'quantity': cp.quantity,
                    'product': cp.product.id,
                  },
                )
                .toList(),
            'dateTime': timeStamp.toIso8601String(),
          },
        ),
      );
      _orders.insert(
        0,
        ItemInOrder(
          id: DateTime.now().toString(),
          amount: total,
          itemsInCart: cartProducts,
          dateTime: timeStamp,
        ),
      ); // Add to front
      notifyListeners();
      print(response.body);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchAndSetOrders(Function getProductFromId) async {
    final url = Uri.parse('${baseUrl}${_pathToOrders}.json');
    final response = await http.get(url);
    final List<ItemInOrder> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach(
      (orderId, orderData) {
        loadedOrders.add(
          ItemInOrder(
            id: orderId,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime']),
            itemsInCart: (orderData['itemsInCart'] as List<dynamic>)
                .map(
                  (item) => ItemInCart(
                    id: item['id'],
                    quantity: item['quantity'],
                    product: getProductFromId(item['product']),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  void minimiseOrders() {
    _orders.forEach((order) {
      order.minimise_order();
    });
  }
}
