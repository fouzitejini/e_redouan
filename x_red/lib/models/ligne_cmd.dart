



import 'product.dart';

class LigneCmd {
  String? key;
  Product? product;
  double? qte;
  double? total = 0.0 ;
  LigneCmd({this.key, this.product, this.qte,this.total});
}
