import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' as f;

import '../../models/bayind_prices_variable.dart';
import '../../models/category.dart';
import '../../models/cmd.dart';
import '../../models/company.dart';
import '../../models/customers.dart';
import '../../models/ligne_cmd.dart';
import '../../models/product.dart';
import '../config/firebase_options.dart';

class Database {
  static Future<void> databaseInitialised() async {
    try {
      await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyCgaHREQwHrG_ruOXf8-kisRxjzKNj5NRk",
              authDomain: "fouzi-87672.firebaseapp.com",
              databaseURL: "https://fouzi-87672.firebaseio.com",
              projectId: "fouzi-87672",
              storageBucket: "fouzi-87672.appspot.com",
              messagingSenderId: "960199945853",
              appId: "1:960199945853:web:3ebe92d7e6cf437dce8b14",
              measurementId: "G-D5CT5EP593"));
      final emulatorHost =
          (!f.kIsWeb && f.defaultTargetPlatform == f.TargetPlatform.android)
              ? '10.0.2.2'
              : 'localhost';

      await FirebaseStorage.instance.useStorageEmulator(emulatorHost, 9199);
      // print(Firebase.apps.length);
    } catch (e) {
      return;
    }
  }

  static Future<void> databaseInitialise() async {
    try {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
    } catch (e) {
      return;
    }
  }

//
  static Map<String, String> categoryToMap(Category category) {
    return {
      "key": category.key!,
      "catName": category.categoryName!,
      "img": category.img!
    };
  }

  static Map<String, String> productToMap(Product product) {
    return {
      "key": product.key!,
      "productName": product.productName!,
      "img": product.img!.toString(),
      "inSales": product.isSale!.toString(),
      "oPrice": product.nPrice!.toString(),
      "sPrice": product.sPrice!.toString(),
      "categorie": product.categorie!.toString(),
      "unit":product.unit!,
      'visibility':product.visiblity.toString()
    };
  }
static Map<String, String> priceVariableToMap(BayPricesVariable product) {
    return {
      "key": product.key!,
      "date": product.date!.toString(),
      "price": product.price!.toString(),
      
    };
  }


 


  static Map<String, String> productToMapCmd(Product product) {
    return {
      "key": product.key!,
      "productName": product.productName!,
      "img": product.img!.toString(),
      "inSales": product.isSale!.toString(),
      "oPrice": product.nPrice!.toString(),
      "sPrice": product.sPrice!.toString(),
      "unit":product.unit!,
       'visibility':product.visiblity.toString()
    
    };
  }

  static Map<String, String> customerToMap(Customer cus) {
    return {
      "key": cus.uKey!.toString(),
      "usrName": cus.userName!,
      "pwd": cus.userPwd!,
      "fullName": cus.fullName!,
      "usrAdresse": cus.adresse!,
      "usrTel": cus.telephone!,
      "usrmail": cus.email!,
    };
  }

  static Map<String, String> cmdToMap(Commandes cmd) {
    return {
      "key": cmd.key!,
      "date": DateTime.now().toString(),
      "livred": cmd.livred == null ? false.toString() : cmd.livred.toString(),
      "confirmed":
          cmd.confirmed == null ? false.toString() : cmd.confirmed.toString(),
      "canceled":
          cmd.canceled == null ? false.toString() : cmd.canceled.toString(),
      "closed": cmd.closed == null ? false.toString() : cmd.closed.toString(),
      "confiremdByAdmin": cmd.confiremdByAdmin == null ? false.toString() : cmd.confiremdByAdmin.toString(),
      "code":cmd.cmdCode!.toString(),
// cmdCode: value['code']??'',
            //  livredDate: DateTime.tryParse(value['livredDate']??DateTime.now().toString()),
    };
  }
  static Map<String, String> cmdToMapLivreson(Commandes cmd) {
    return {
      "key": cmd.key!,
      "date": DateTime.now().toString(),
      "livred": cmd.livred == null ? false.toString() : cmd.livred.toString(),
      "confirmed":
          cmd.confirmed == null ? false.toString() : cmd.confirmed.toString(),
      "canceled":
          cmd.canceled == null ? false.toString() : cmd.canceled.toString(),
      "closed": cmd.closed == null ? false.toString() : cmd.closed.toString(),
      "confiremdByAdmin": cmd.confiremdByAdmin == null ? false.toString() : cmd.confiremdByAdmin.toString(),
      "code":cmd.cmdCode!.toString(),
      'livredDate':cmd.livredDate!.toString()
// cmdCode: value['code']??'',
            //  livredDate: DateTime.tryParse(value['livredDate']??DateTime.now().toString()),
    };
  }

  static Map<String, String> cmdLineToMap(LigneCmd cmd, Product product) {
    return {
      "key": cmd.key!,
      "qte": cmd.qte.toString(),
    };
  }

  static Product getProduct(Map productMap) {
    var product = Product(
      key: productMap['key']??'',
      img: productMap['img']??'',
      isSale: productMap['inSales'] == 'true' ? true : false,
      productName: productMap['productName']??'',
      nPrice: double.parse(productMap['oPrice']??0),
      sPrice: double.parse(productMap['sPrice']??0),
      unit: productMap['unit']??'',
      visiblity: productMap['visibility'].toString() == 'true' ? true : false ,
    );
    return product;
  }

  static Company getCompany(Map companyMap) {
    var company = Company(
      companyName: companyMap['companyName']??'',
      telephone: companyMap['telephone']??'',
      fix: companyMap['fix']??'',
      fax: companyMap['fax']??'',
      email: companyMap['email']??'',
      adresse: companyMap['adresse']??'',
      cartLimitMnt: companyMap['cartLimitMnt']??'',
      shortDescription: companyMap['shortDescription']??'',
      cartLimitDescription: companyMap['cartLimitDescription']??'',
      whatsapp: companyMap['whatsapp']??'',
      faceBook: companyMap['faceBook']??'',
      logo:companyMap['faceBook']??'',
      about:companyMap['about']??'',
      user: companyMap['user']??'',
      pwd: companyMap['pwd']??''
    );
    return company;
  }

  static Map<String,Object?> companyToMap(Company company) {
    return {
    "companyName":company.companyName,
    'telephone':company.telephone,
    'fix':company.fix,
    'fax':company.fax,
    'about':company.about,
    'email':company.email,
    'adresse':company.adresse,
     'cartLimitMnt':company.cartLimitMnt,
     'shortDescription':company.shortDescription,
     'cartLimitDescription':company.cartLimitDescription,
     'whatsapp':company.whatsapp,
     'faceBook':company.faceBook,
     'logo':company.logo,
     'user':company.user,
     "pwd":company.pwd

    };
  }
}
/** String? companyName;
  String? telephone;
  String? fix;
  String? fax;
  String? whatsapp;
  String? faceBook;
  String? shortDescription;
  String? email;
  String? adresse;
  String? cartLimitDescription;
  double? cartLimitMnt; */

/** String? key;
  Product? product;
  double? qte; */