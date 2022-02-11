import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../providers/product.dart';
import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  final Product product;

  UserProductItem(
    this.product,
  );

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return Card(
      child: ListTile(
        title: Text(product.title),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.black54,
          child: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(product.imageUrl),
          ),
        ),
        trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(EditProductScreen.routeName,
                      arguments: product);
                },
                icon: Icon(Icons.edit),
                color: Theme.of(context).primaryColor,
              ),
              IconButton(
                onPressed: () async {
                  try {
                    await Provider.of<Products>(context, listen: false)
                        .deleteProduct(product);
                  } catch (error) {
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Text(
                          'Deleting failed!',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                },
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
