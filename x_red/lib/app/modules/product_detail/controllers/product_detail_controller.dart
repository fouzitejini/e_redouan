import 'dart:html';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../../data/reposetory/commande_data.dart';
import '../../../../data/reposetory/product_data.dart';
import '../../../../models/cmd.dart';
import '../../../../models/customers.dart';
import '../../../../models/ligne_cmd.dart';
import '../../../../models/product.dart';
import '../../../../utilities/ext.dart';
import '../../home/controllers/home_controller.dart';

class DatailParametres {
  final bool? backSpace;
  final String? key;
  DatailParametres({this.key, this.backSpace});
}

class ProductDetailController extends GetxController {

  final backSpace = Get.find<HomeController>().backVisible;
  final productData = ProductData();
  final isOnload = true.obs;
  final isLoaded = false.obs;
  final isError = false.obs;
  final sum = 0.0.obs;
  final items = <Product>[].obs;
  final item = Product().obs;
  final val = false.obs;
  final qte = 1.0.obs;
  final imgStoragePath = ''.obs;
  var productUploadedImagePath = ''.obs;
  final imageUploaded = true.obs;
  final cmd = CustomerCommandes();
  final cmdIDOP = ''.obs;
  final userID = ''.obs;
  final uuid = const Uuid().obs;
  final cmds = <Commandes>[].obs;
  final newCommand = true.obs;
  Future<String> get getUid async {
    if ((await box.read('userKey')) == null) {
      await box.write(
        'userKey',
        uuid.value.v1(),
      );
    }
    return await box.read('userKey');
  }

  Future<String> get getCmdO async {
    if ((await box.read('cmd')) == null) {
      await box.write(
        'cmd',
        uuid.value.v1(),
      );
    }
    return await box.read('cmd');
  }

  Future<void> init() async {
    await getCmdO.then((value) => cmdIDOP.value = value);
    await getUid.then((value) => userID.value = value);
    await productData.readI().then((value) => items.value = value);
    await cmd
        .readcmd(Customer(uKey: userID.value))
        .then((value) => cmds.value = value);
  }

  @override
  void onInit() async {
    try {
      await getCmdO.then((value) => cmdIDOP.value = value);
      await getUid.then((value) => userID.value = value);
      await cmd
          .readcmd(Customer(uKey: userID.value))
          .then((value) => cmds.value = value);
      await productData.readI().then((value) => items.value = value);

      productDetail();
      isOnload.value = true;
      isLoaded.value = false;
      isError.value = false;
    } catch (e) {
      isOnload.value = false;
      isLoaded.value = false;
      isError.value = true;
      return;
    } finally {
      isOnload.value = false;
      isLoaded.value = true;
      isError.value = false;
    }
    super.onInit();
  }

  saveCmd(Customer customer, Commandes cmdo, LigneCmd cmdline,
      Product product) async {
    await cmd.createLineCmd(customer, cmdo, cmdline, product);
    await cmd.createProductLineCmd(customer, cmdo, cmdline, product);
  }

  void productDetail() async {
    var uri = Uri.dataFromString(window.location.href);
    if (uri.queryParameters.isNotEmpty) {
      var par = uri.queryParameters['p'].toString();
    
      item.value = items.firstWhere((element) => element.key == par);
     
      val.value = true;
      return;
    }
  }

  Future<void> createO() async {
    await Get.find<HomeController>().createO();
  }
}
