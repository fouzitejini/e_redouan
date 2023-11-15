import 'package:firebase_database/firebase_database.dart';
import 'package:redouanstore/data/reposetory/firebase_database.dart';

import '../../models/bayind_prices_variable.dart';
import '../../models/product.dart';

class ProductData {
  void create(Product p) async {
    try {
     
      await FirebaseDatabase.instance
          .ref("Products")
          .child(p.key!)
          .set(Database.productToMap(p));
    } catch (e) {
  
    }
  }
    void creatProductVariable(BayPricesVariable p) async {
    try {
     
      await FirebaseDatabase.instance
          .ref("ProductVariable")
          .child(p.key!)
          .set(Database.priceVariableToMap(p));
    } catch (e) {
  
    }
  }
  void creatProductInVariable(BayPricesVariable p) async {
    try {
     
      await FirebaseDatabase.instance
          .ref("ProductVariable")
          .child(p.key!)
          .child('Product')
          .set(Database.productToMap(p.product!));
    } catch (e) {
  
    }
  }

  void delete(c, p) {
    FirebaseDatabase.instance.ref("Products").child(p.key!).remove();
  }

  Future<List<String>> get read => throw UnimplementedError();

  void update(c, Product p) {
    FirebaseDatabase.instance
        .ref("Products")
        .child(p.key!)
        .update(Database.productToMap(p));
  }

  Future<List<Product>> readI() async {
    List<Product> products = [];
    try {
      var ref = FirebaseDatabase.instance.ref("Products");

      await ref.once().then((DatabaseEvent event) {
        if (event.snapshot.value != null) {
          Map<dynamic, dynamic> dataMap = Map<String, dynamic>.from(
              event.snapshot.value as Map<Object?, Object?>);
          dataMap.forEach((key, value) {
            var curproduct = Product(
              productName: value["productName"],
              key: value["key"].toString(),
              img: value["img"].toString(),
              isSale: value["inSales"] == "true" ? true : false,
              nPrice: double.parse(value["oPrice"].toString()),
              sPrice: double.parse(value["sPrice"].toString()),
              unit: value["unit"].toString().replaceAll('unit', 'وحدة'),
              categorie: value["categorie"].toString(),
              visiblity: value['visibility'] == "true" ? true : false,
            );

            products.add(curproduct);
          });
        }
      });
    } catch (e) {}

    return products;
  }
}
