import 'package:redouanstore/models/product.dart';

class BayPricesVariable {
  String? key;
  DateTime? date;
  double? price;
  Product? product;
  BayPricesVariable({this.key, this.date, this.price, this.product});
}
