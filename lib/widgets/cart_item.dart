import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../models/item_in_cart.dart';

class CartItem extends StatelessWidget {
  final ItemInCart itemInCart;

  CartItem(this.itemInCart);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false)
            .removeItem(itemInCart.product);
      },
      key: ValueKey(itemInCart.id),
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(child: Text('£${itemInCart.product.price}')),
              ),
            ),
            title: Text(itemInCart.product.title),
            subtitle: Text(
                'Total: £${itemInCart.product.price * itemInCart.quantity}'),
            trailing: Text('${itemInCart.quantity} x'),
          ),
        ),
      ),
    );
  }
}
