

import 'package:redouanstore/models/product.dart';

class Category {
  String? key;
  String? categoryName;
  String? maskedName;
  String? img;
  List<Product>? products;
  Category({this.key, this.categoryName, this.img, this.maskedName,this.products});
}
