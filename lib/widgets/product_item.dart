import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth_data = Provider.of<Auth>(context, listen: false);
    return Card(
      shape: RoundedRectangleBorder(
          side: new BorderSide(
            color: Theme.of(context).accentColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(0),
      elevation: 6,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              width: double.infinity,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                      arguments: product);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  child: Hero(
                    tag: product.id,
                    child: FadeInImage(
                      placeholder: AssetImage('assets/images/tess.jpeg'),
                      image: NetworkImage(
                        product.imageUrl,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Consumer<Product>(
                builder: (_, value, __) => IconButton(
                  alignment: Alignment.centerLeft,
                  splashRadius: 19,
                  icon: Icon(
                    value.isFavourite ? Icons.favorite : Icons.favorite_border,
                    color: Theme.of(context).accentColor,
                  ),
                  onPressed: () {
                    value.toggleFavouriteStatus(
                        auth_data.token, auth_data.userId);
                  },
                ),
              ),
              Expanded(
                child: Text(
                  product.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              IconButton(
                alignment: Alignment.centerRight,
                splashRadius: 19,
                icon: Icon(
                  Icons.shopping_cart,
                ),
                onPressed: () {
                  cart.addItem(product);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Added item to cart!'),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.removeSingleItem(product);
                      },
                    ),
                  ));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
