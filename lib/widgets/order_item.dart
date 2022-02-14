import 'dart:math';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/item_in_order.dart';
import '../providers/orders.dart';

class OrderItem extends StatefulWidget {
  final ItemInOrder itemInOrder;

  OrderItem(this.itemInOrder);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => Provider.of<Orders>(context, listen: false).minimiseOrders());
  }

  @override
  Widget build(BuildContext context) {
    ItemInOrder item = Provider.of<ItemInOrder>(context);
    Orders orders = Provider.of<Orders>(context, listen: false);
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('£${widget.itemInOrder.amount.toStringAsFixed(2)}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy HH:mm')
                  .format(widget.itemInOrder.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(item.expanded ? Icons.expand_more : Icons.expand_less),
              onPressed: () {
                if (item.expanded) {
                  item.minimise_order();
                } else {
                  orders.minimiseOrders();
                  item.expand_order();
                }
              },
            ),
          ),
          if (item.expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: widget.itemInOrder.numberOfProducts * 20 + 30.toDouble(),
              child: ListView.builder(
                itemBuilder: (_, index) => Container(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.itemInOrder.itemsInCart[index].product.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${widget.itemInOrder.itemsInCart[index].quantity}x £${widget.itemInOrder.itemsInCart[index].product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                itemCount: widget.itemInOrder.numberOfProducts,
              ),
            )
        ],
      ),
    );
  }
}
