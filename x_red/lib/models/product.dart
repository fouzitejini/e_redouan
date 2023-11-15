
class Product {
  String? key;
  String? productName;
  String? img;
  double? nPrice;
  double? sPrice;
  bool? isSale;
  String? categorie;
  String? unit;
  bool visiblity= false;

  Product(
      {this.key,
      this.productName,
      this.img,
      this.nPrice,
      this.sPrice,
      this.isSale,
      this.categorie,
      this.unit,this.visiblity=false});
}
