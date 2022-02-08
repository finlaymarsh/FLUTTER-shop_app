import 'package:flutter/foundation.dart';
import '../providers/product.dart';

class ItemInCart {
  final String id;
  final int quantity;
  final Product product;

  ItemInCart({
    @required this.id,
    @required this.quantity,
    @required this.product,
  });
}
