import 'dart:html';

import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:randomstring_dart/randomstring_dart.dart';
import 'package:redouanstore/utilities/sum.dart';
import 'package:uuid/uuid.dart';

import '../../../../data/reposetory/categorie_data.dart';
import '../../../../data/reposetory/commande_data.dart';
import '../../../../data/reposetory/company_settings_data.dart';
import '../../../../data/reposetory/customer_data.dart';

import '../../../../data/reposetory/product_data.dart';
import '../../../../models/category.dart';
import '../../../../models/cmd.dart';
import '../../../../models/company.dart';
import '../../../../models/customers.dart';
import '../../../../models/ligne_cmd.dart';
import '../../../../models/product.dart';
import '../../../../utilities/ext.dart';
import 'headfootcontroller_controller.dart';

class HomeController extends GetxController {
   
  final cnt = Get.put(HeaderController());
  var companyData = CompanySettings();
  final backVisible = false.obs;
  final company = Company().obs;
  final cmd = CustomerCommandes();
  final productData = ProductData();
  final currentCustomer = Customer().obs;
  final errorMessage = "Error".obs;
  final newCommand = true.obs;
  final uuid = const Uuid().obs;
  final onLoad = true.obs;
  final loaded = false.obs;
  final error = false.obs;
  final cmds = <Commandes>[].obs;
  final lCmds = <LigneCmd>[].obs;
  final categories = <Category>[].obs;
  final categoryReposetory = CategoriesData();
  final products = <Product>[].obs;
  final badgeQte = 0.0.obs;
  //final cnt.cmdIDOP = ''.obs;
  //final cnt.userID = ''.obs;
  final customerData = CustomerData();
  final categorie = Category().obs;
  Future<void> init() async {
    await companyData.getCompanyData.then((value) {
      company.value = value;
    });
    await productData.readI().then((value) => products.value =
        value.where((element) => element.visiblity == true).toList());
           await categoryReposetory.readCategories.then((value) {
      categories.value = value
          .where((element) => element.products!
              .where((element) => element.visiblity)
              .isNotEmpty)
          .toList();
    }).timeout(const Duration(seconds: 20), onTimeout: () {
      error.value = true;
    });
  //  await category.then((value) => categorie.value = value);
    await getCmdO.then((value) => cnt.cmdIDOP.value = value);
    await getUid.then((value) => cnt.userID.value = value);
    await customerData.readCustomers.then((value) async {
      if (value.where((element) => element.uKey == cnt.userID.value).isEmpty) {
        currentCustomer.value = Customer(
            uKey: cnt.userID.value,
            userName: '',
            userPwd: '',
            fullName: '',
            adresse: "",
            email: '',
            telephone: '',
            cart: cnt.cmdIDOP.value);
        await customerData.create(currentCustomer.value);
      } else {
        currentCustomer.value =
            value.firstWhere((element) => element.uKey == cnt.userID.value);
      }
    });
    await cmd
        .readcmd(Customer(uKey: cnt.userID.value))
        .then((value) => cmds.value = value);

 
    await cmd
        .readProductInCMD(
            Customer(uKey: cnt.userID.value), Commandes(key: cnt.cmdIDOP.value))
        .then((value) => lCmds.value = value);
   
    //badgeQte.value = cartProducts(lCmds).length.toDouble();
  }

  @override
  void onInit() async {
    try {
      //  Timer.
      onLoad.value = true;
      loaded.value = false;
      error.value = false;
      await init();
    } catch (e) {
      error.value = true;
      errorMessage.value = 'Error: $e';

      onLoad.value = false;
      loaded.value = false;
      return;
    } finally {
      errorMessage.value = 'Error: ';
      onLoad.value = false;
      loaded.value = true;
      error.value = false;
    }
    super.onInit();
  }

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
      var xx = await box.read('cmd');
      await cmd.createCustomerCmd(
          currentCustomer.value,
          Commandes(
              key: xx,
              date: DateTime.now(),
              livred: false,
              confirmed: false,
              canceled: false,
              closed: false,
              customer: Customer(uKey: cnt.userID.value)));
    }

    return await box.read('cmd');
  }

  Future<void> session() async {
    cnt.cmdIDOP.value = await getCmdO;
    currentCustomer.value =
        Customer(uKey: cnt.userID.value, connected: false, cart: cnt.cmdIDOP.value);
  }

  saveCmd(Customer customer, Commandes cmdo, LigneCmd cmdline,
 
      Product product) async {
        

    await cmd.createLineCmd(customer, cmdo, cmdline, product);
    await cmd.createProductLineCmd(customer, cmdo, cmdline, product);
  }

  Future<void> createO() async {
    await getCmdO.then((value) => cnt.cmdIDOP.value = value);

    var x = cmds
        .where((p0) => p0.key == cnt.cmdIDOP.value)
        .where((p) => !p.confirmed! && !p.canceled! && !p.livred! && !p.closed!)
        .toList();

    if (x.isEmpty) {
      await getCmdO.then((value) async {
        cnt.cmdIDOP.value = value;
        currentCustomer.value.cart = value;
      }).whenComplete(() async {
        return;
      });
      await getCmdO.then((value) => cnt.cmdIDOP.value = value);
    }
  }

  List<LigneCmd> cartProducts(List<LigneCmd> items) {
    List<LigneCmd> productsL = [];

    Map<String, List<LigneCmd>> groupedItems =
        groupBy(items, (item) => item.product!.key!);
    groupedItems.forEach((key, value) {
      // print(productsI.firstWhere((element) => element.key == key).cmdKey);
      productsL.add(LigneCmd(
          product: products.firstWhere((element) => element.key == key),
          qte: value.sumTotal((el) => el.qte!).toDouble()));
    });

    return productsL;
  }

  Future<Category> get category async {
   
    
    var uri = Uri.dataFromString(window.location.href);
    if (uri.queryParameters.isNotEmpty) {
      var par = uri.queryParameters['c'].toString();
     
      return categories.firstWhere((element) => element.key == par);
    }
    return Category();
  }
}
/**await cmd.createCmd(
           currentCustomer.value,
          Commandes(
              key: cnt.cmdIDOP.value,
              date: DateTime.now(),
              livred: false,
              confirmed: false,
              canceled: false,
              closed: false,
              customer: Customer(uKey: cnt.userID.value))); */