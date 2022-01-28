import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          side: new BorderSide(
            color: Theme.of(context).primaryColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(0),
      elevation: 6,
      child: Column(
        children: <Widget>[
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  Container(
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      product.title,
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: IconButton(
                      alignment: Alignment.centerLeft,
                      splashRadius: 19,
                      icon: Icon(Icons.favorite),
                      onPressed: () {},
                    ),
                  ),
                  Expanded(
                    child: Text(
                      product.title,
                      style: TextStyle(
                          fontSize: 16, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  Flexible(
                    child: IconButton(
                      alignment: Alignment.centerRight,
                      splashRadius: 19,
                      icon: Icon(Icons.shopping_cart),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
