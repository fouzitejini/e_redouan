// ignore_for_file: prefer_const_constructors

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';


import '../../models/category.dart';
import '../../models/product.dart';
import '../colors.dart';
import 'firebase_database.dart';

class CategoriesData {
  Stream<List<Category>> get readCategory async* {
    List<Category> category = [];
    List<Product> products = [];

    await readI().then((value) => products = value);

    var ref = FirebaseDatabase.instance.ref("Category");

    await ref.once().then((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> dataMap = Map<dynamic, dynamic>.from(
            event.snapshot.value as Map<Object?, Object?>);
        dataMap.forEach((key, value) async {
          category.add(Category(
              categoryName: value["catName"],
              key: value["key"],
              img: value["img"],
              products: products));
        });
      }
    });

    yield category;
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
            products.add(Product(
                productName: value["productName"],
                key: value["key"].toString(),
                img: value["img"].toString(),
                isSale: value["inSales"] == "true" ? true : false,
                nPrice: double.parse(value["oPrice"].toString()),
                sPrice: double.parse(value["sPrice"].toString()),
                categorie: value["categorie"].toString(),
                visiblity: value["visibility"].toString() == "true" ? true : false,
                unit:value["unit"].replaceAll('unit', 'وحدة')) );
                
          });
        }
      });
    } catch (e) {
      print(e);
    }

    return products;
  }

  Future<List<Category>> get readCategories async {
    List<Category> category = [];
    List<Product> products = [];

    await readI().then((value) => products = value);

    var ref = FirebaseDatabase.instance.ref("Category");

    await ref.once().then((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> dataMap = Map<dynamic, dynamic>.from(
            event.snapshot.value as Map<Object?, Object?>);
        dataMap.forEach((key, value) async {
          category.add(Category(
              categoryName: value["catName"],
              key: value["key"],
              img: value["img"],
              products: products
                  .where((element) => element.categorie! == value["key"] && element.visiblity)
                  .toList()));
        });
      }
    });

    return category;
  }

  Future<void> create(Category object) async {
    try {
      await FirebaseDatabase.instance
          .ref("Category")
          .child(object.key!)
          .set(Database.categoryToMap(object));
    } catch (e) {}
  }

Future<void> update(Category object) async {
    try {
      await FirebaseDatabase.instance
          .ref("Category")
          .child(object.key!)
          .update(Database.categoryToMap(object));
    } catch (e) {}
  }
  Future<void> delete(Category object) async {
    if (object.products!.isNotEmpty) {
      Get.showSnackbar(GetSnackBar(
        titleText: Row(
          children: [
            Text(
              "تنبيه",
              style: TextStyle(color: BrandColors.backgrounGray),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.warning,
                color: Colors.yellow,
              ),
            ),
          ],
        ),
        message: "لا يمكنك حذف هذا الصنف لان به منتج اواكثر",
      ));
      return;
    }
    removeCategory(object);
  }

  void removeCategory(Category object) async {
    await FirebaseDatabase.instance
        .ref()
        .child("Category")
        .child(object.key!)
        .remove();
  }
}
