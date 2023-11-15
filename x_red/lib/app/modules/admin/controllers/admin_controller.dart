// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:convert';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:randomstring_dart/randomstring_dart.dart';
import 'package:redouanstore/data/colors.dart';
import 'package:redouanstore/utilities/sum.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../../../../data/reposetory/commande_data.dart';
import '../../../../data/reposetory/company_settings_data.dart';
import '../../../../data/reposetory/product_data.dart';
import '../../../../models/admin_menu.dart';
import '../../../../models/cmd.dart';
import '../../../../models/company.dart';
import '../../../../models/customers.dart';
import '../../../../models/ligne_cmd.dart';
import '../../../../models/product.dart';

import '../../../../utilities/ext.dart';
import '../views/admin_home_view.dart';
import 'admi_menu_controller_controller.dart';

class AdminController extends GetxController {
  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  Future<DateTime> get ssesionTime async {
    if ((await box.read('sessionTime')) == null) {
      // await box.write('sessionTime', DateTime.now());
      return DateTime(2000, 1, 1);
    }

    DateTime sess = DateTime.parse(box.read('sessionTime').toString());
    return sess;
  }

  checkSession() async {
    await ssesionTime.then((value) {
      if (DateTime.now().difference(value).inSeconds > 3600) {
        deadSession.value = true;
      } else {
        deadSession.value = false;
      }
    });
  }

  checkLogin() async {
    if (company.value.user!.isEmpty && company.value.pwd!.isEmpty) {
      if (adminUserController.value.text == 'admin' &&
          adminPwdController.value.text == 'admin') {
        deadSession.value = false;
        await box.write('sessionTime', DateTime.now().toString());
        adminPwdController.value.text = '';
        adminUserController.value.text = '';
      } else {
        showDialog(
            context: Get.context!,
            builder: (_) => Dialog(
                  child: SizedBox(
                    height: 250,
                    width: 250,
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "تنبيه",
                          style: TextStyle(
                              fontSize: 22, color: BrandColors.googleRed),
                        ),
                      ),
                      Expanded(
                        child: Center(
                            child: Text(
                          "اسم المستخدم او رمز الدخول خاطئ",
                          style: TextStyle(
                              fontSize: 17, color: BrandColors.xboxGrey),
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 40,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      Get.back();
                                    },
                                    child: const Text(
                                      "انهاء",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ]),
                  ),
                ));
        deadSession.value = true;
      }
    } else {
      if (adminUserController.value.text == company.value.user! &&
          generateMd5(adminPwdController.value.text) == company.value.pwd!) {
        deadSession.value = false;
        await box.write('sessionTime', DateTime.now().toString());
        adminPwdController.value.text = '';
        adminUserController.value.text = '';
      } else {
        showDialog(
            context: Get.context!,
            builder: (_) => Dialog(
                  child: SizedBox(
                    height: 250,
                    width: 250,
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "تنبيه",
                          style: TextStyle(
                              fontSize: 22, color: BrandColors.googleRed),
                        ),
                      ),
                      Expanded(
                        child: Center(
                            child: Text(
                          "اسم المستخدم او رمز الدخول خاطئ",
                          style: TextStyle(
                              fontSize: 17, color: BrandColors.xboxGrey),
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 40,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      Get.back();
                                    },
                                    child: const Text(
                                      "انهاء",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ]),
                  ),
                ));
        deadSession.value = true;
      }
    }
  }

  final waitToUpload = true.obs;
  final imageUploadedName = ''.obs;
  final uuid = const Uuid().obs;
  final slideImages = <String>[].obs;
  final x = <LigneCmd>[].obs;
  final chartData = <ChartData>[].obs;
  final deadSession = true.obs;
  final companyNameController = TextEditingController().obs;
  final GlobalKey<FormState> form = GlobalKey<FormState>();
  final companyTelephoneController = TextEditingController().obs;
  final companyFixController = TextEditingController().obs;
  final companyFaxController = TextEditingController().obs;
  final companyWahtsappController = TextEditingController().obs;
  final minCartCostController = TextEditingController().obs;
  final minCartCostDescriptionController = TextEditingController().obs;
  final companyFacebookController = TextEditingController().obs;
  final companyEmailController = TextEditingController().obs;
  final adminUserController = TextEditingController().obs;
  final adminPwdController = TextEditingController().obs;
  final companyDetaiController = TextEditingController().obs;
  final companyAboutController = TextEditingController().obs;
  final isItemInSale = false.obs;
  final maxQte = 0.0.obs;
  final itemKey = TextEditingController().obs;
  final itemDetail = TextEditingController().obs;
  final itemPrice = TextEditingController().obs;
  final imageUploaded = true.obs;
  final imgStoragePath = ''.obs;
  var categoryUploadedImage = Uint8List(0).obs;
  var categoryUploadedImagePath = ''.obs;
  var index = 1.obs;
  var menu = <AdminMasterMenu>[].obs;
  final onLoad = true.obs;
  final loaded = false.obs;
  final error = false.obs;
  final customerData = CustomerCommandes();
  final customersU = <Customer>[].obs;
  final company = Company().obs;
  final customersHasCmd = <Customer>[].obs;
  final cmds = <Commandes>[].obs;
  final actifCmds = <Commandes>[].obs;
  final ligneCmdB = <LigneCmd>[].obs;
  final ligneCmdS = <LigneCmd>[].obs;
  final ligneCmdEarning = <LigneCmd>[].obs;
  final allUsersCommande = <LigneCmd>[].obs;
  final products = <Product>[].obs;
  final productData = ProductData();
  var productUploadedImage = Uint8List(0).obs;
  var companyData = CompanySettings();
  final confirmCMD = Commandes().obs;
  final cntPage = PageController().obs;
  final indexPage = 0.obs;
  final dilevryDate = DateTime(DateTime.now().year).obs;
  Future<void> getCompanySettings() async {
    await companyData.getCompanyData.then((value) => company.value = value);
  }

  Future<void> loadData() async {
    await customerData.readCustomers.then(
      (value) {
        customersU.value = value;
        initDataCmd();
      },
    );
    checkSession();
    await getCompanySettings();
    await productData.readI().then((value) {
      value.forEach((element) {});
      return products.value = value;
    }).whenComplete(() => null);

    getCustomerHasCmdConfirmed.listen((event) {
      actifCmds.clear();
      event.forEach((element) {
        actifCmds.addAll(element.cartData!.where((element) =>
            element.livred == false &&
            element.canceled == false &&
            element.confiremdByAdmin == true &&
            element.confirmed == true));
      });
    });
  }

  void load() async {
    await loadData();
  }

//متجر الرضون
  @override
  void onInit() async {
    try {
      menu = Get.find<AdminMenuController>().menu;
      index = Get.find<AdminMenuController>().index;

      onLoad.value = true;
      loaded.value = false;
      error.value = false;
      await loadData().whenComplete(() => null);
    } catch (e) {
      onLoad.value = false;
      loaded.value = false;
      error.value = true;
    } finally {
      loaded.value = true;
      error.value = false;
      onLoad.value = false;
    }
    super.onInit();
  }

  Stream<List<Customer>> get getCustomer async* {
    yield customersU;
  }

  Stream<List<Customer>> get getCustomerHasCmd async* {
    List<Customer> cusos = [];
    customersU.forEach((element) {
      if (element.cartData!
          .where((element) =>
              element.livred == false &&
              element.canceled == false &&
              element.closed == false &&
              element.confiremdByAdmin == false &&
              element.confirmed == true)
          .isNotEmpty) {
        cusos.add(element);
      }
    });
    yield cusos;
  }

  Stream<List<Customer>> get getCustomerHasCmdConfirmed async* {
    List<Customer> cusos = [];
    customersU.forEach((element) {
      if (element.cartData!
          .where((element) =>
              element.livred == false &&
              element.canceled == false &&
              element.closed == false &&
              element.confiremdByAdmin == true &&
              element.confirmed == true)
          .isNotEmpty) {
        cusos.add(element);
      }
    });
    yield cusos;
  }

  List<LigneCmd> cartProducts(List<LigneCmd> items) {
    List<LigneCmd> productsL = [];

    Map<String, List<LigneCmd>> groupedItems =
        groupBy(items, (item) => item.product!.key!);
    groupedItems.forEach((key, value) {
      productsL.add(LigneCmd(
          product: products.firstWhere((element) => element.key == key),
          qte: value.sumTotal((el) => el.qte!).toDouble()));
    });

    return productsL;
  }

  List<LigneCmd> cartProductsEarnig(List<LigneCmd> items) {
    List<LigneCmd> productsL = [];

    Map<String, List<LigneCmd>> groupedItems =
        groupBy(items, (item) => item.product!.key!);
    groupedItems.forEach((key, value) {
      productsL.add(LigneCmd(
          product: products.firstWhere((element) => element.key == key),
          qte: value.sumTotal((el) => el.qte!).toDouble()));
    });

    return productsL;
  }

  List<LigneCmd> cartProductsTot(List<LigneCmd> items) {
    List<LigneCmd> productsL = [];

    Map<String, List<LigneCmd>> groupedItems =
        groupBy(items, (item) => item.product!.key!);
    groupedItems.forEach((key, value) {
      productsL.add(LigneCmd(
          product: products.firstWhere((element) => element.key == key),
          qte: value.sumTotal((el) => el.qte!).toDouble()));
    });

    return productsL;
  }

  Future<void> uploadFileToBase64() async {
    productUploadedImage.value = (await ImagePickerWeb.getImageAsBytes())!;
  }

  Future<Uri?> uploadFile(Uint8List image, String ref, String fileName) async {
    imageUploaded.value = false;
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageReference = storage.ref().child(ref).child(fileName);
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
      );
      UploadTask uploadTask = storageReference.putData(image, metadata);
      await uploadTask.whenComplete(() {
        imageUploaded.value = true;
      });

      String downloadURL = await storageReference.getDownloadURL();
      categoryUploadedImagePath.value = downloadURL;

      return Uri.parse(downloadURL);
    } catch (e) {
      return null;
    }
  }

  Future<void> uploadImageToStorage() async {
    await uploadFile(categoryUploadedImage.value, 'ImagesFiles',
            companyNameController.value.text)
        .then((value) => imgStoragePath.value = value.toString());
  }

  Future<void> uploadImageSliderToStorage() async {
    final rs = RandomString();
    await uploadFile(
        productUploadedImage.value,
        'slider',
        rs.getRandomString(
          uppersCount: 10,
          lowersCount: 10,
          numbersCount: 0,
          specialsCount: 0,
        )).then((value) => imgStoragePath.value = value.toString());
  }

  Future<Uint8List> networkImageToBase64() async {
    http.Response response = await http.get(
        Uri.parse("https://cdn-icons-png.flaticon.com/128/212/212736.png"));
    final bytes = response.bodyBytes;
    return bytes;
  }

  Future<Uint8List> networkImageToBase64OnEdit(String path) async {
    try {
      http.Response response = await http.get(Uri.parse(imgStoragePath.value));
      final bytes = response.bodyBytes;
      categoryUploadedImage.value = bytes;
      return bytes;
      // ignore: empty_catches
    } catch (e) {}
    return Uint8List(0);
  }

  showCartCompnaySettings() {
    showDialog(
        context: Get.context!,
        builder: (_) => Dialog(
              child: Form(
                key: form,
                child: SizedBox(
                  width: 400,
                  height: 500,
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 0, top: 20, bottom: 20, right: 20),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    textAlign: TextAlign.end,
                                    textDirection: TextDirection.ltr,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'(^\d*\.?\d{0,2})'))
                                    ],
                                    controller: minCartCostController.value,
                                    validator: ValidationBuilder()
                                        .minLength(1)
                                        .build(),
                                    decoration: InputDecoration(
                                        suffixText: 'درهم',
                                        border: const OutlineInputBorder(
                                            borderSide: BorderSide(width: 1)),
                                        labelText: "ثمن تخفيض المنتج".tr,
                                        isCollapsed: true,
                                        contentPadding: const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: 10,
                                            bottom: 10)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, top: 20, bottom: 20, right: 20),
                                child: Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: TextFormField(
                                    controller:
                                        minCartCostDescriptionController.value,
                                    validator: ValidationBuilder()
                                        .minLength(3)
                                        .build(),
                                    decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                            borderSide: BorderSide(width: 1)),
                                        labelText: "وصف المنتج".tr,
                                        isCollapsed: true,
                                        contentPadding: const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: 10,
                                            bottom: 10)),
                                    maxLines: null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                onPressed: () async {
                                  company.value.cartLimitDescription =
                                      minCartCostDescriptionController
                                          .value.text;
                                  company.value.cartLimitMnt = double.tryParse(
                                      minCartCostController.value.text);
                                  companyData.updateCompany(company.value);
                                  await getCompanySettings();
                                  Get.back();
                                },
                                child: Text("حفظ التعديل".tr)),
                          )),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                onPressed: () {},
                                child: Text("الغاء التعديل".tr)),
                          ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ));
  }

  showCompanySettings() {
    showDialog(
        context: Get.context!,
        builder: (_) => Dialog(
              child: Form(
                key: form,
                child: SizedBox(
                  width: Get.width,
                  height: Get.height,
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, top: 20, bottom: 20, right: 20),
                                child: Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: TextFormField(
                                    onChanged: (e) {},
                                    controller: companyNameController.value,
                                    validator: ValidationBuilder()
                                        .minLength(3)
                                        .build(),
                                    decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                            borderSide: BorderSide(width: 1)),
                                        labelText: "اسم المؤسسة".tr,
                                        isCollapsed: true,
                                        contentPadding: const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: 10,
                                            bottom: 10)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, top: 20, bottom: 20, right: 20),
                                child: Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: TextFormField(
                                    controller: companyDetaiController.value,
                                    validator: ValidationBuilder()
                                        .minLength(3)
                                        .build(),
                                    decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                            borderSide: BorderSide(width: 1)),
                                        labelText: "وصف المؤسسة".tr,
                                        isCollapsed: true,
                                        contentPadding: const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: 10,
                                            bottom: 10)),
                                    maxLines: null,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 0, top: 20, bottom: 20, right: 20),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    textAlign: TextAlign.end,
                                    textDirection: TextDirection.ltr,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'(^\d*\.?\d{0,2})'))
                                    ],
                                    controller: companyFixController.value,
                                    validator:
                                        ValidationBuilder().phone().build(),
                                    decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                            borderSide: BorderSide(width: 1)),
                                        labelText: "رقم الهاتف الثابت".tr,
                                        isCollapsed: true,
                                        contentPadding: const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: 10,
                                            bottom: 10)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 0, top: 20, bottom: 20, right: 20),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    textAlign: TextAlign.end,
                                    textDirection: TextDirection.ltr,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'(^\d*\.?\d{0,2})'))
                                    ],
                                    controller:
                                        companyTelephoneController.value,
                                    validator:
                                        ValidationBuilder().phone().build(),
                                    decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                            borderSide: BorderSide(width: 1)),
                                        labelText: "رقم الهاتف الجوال".tr,
                                        isCollapsed: true,
                                        contentPadding: const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: 10,
                                            bottom: 10)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 0, top: 20, bottom: 20, right: 20),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    textAlign: TextAlign.end,
                                    textDirection: TextDirection.ltr,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'(^\d*\.?\d{0,2})'))
                                    ],
                                    controller: companyWahtsappController.value,
                                    validator:
                                        ValidationBuilder().phone().build(),
                                    decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                            borderSide: BorderSide(width: 1)),
                                        labelText: "الواتساب".tr,
                                        isCollapsed: true,
                                        contentPadding: const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: 10,
                                            bottom: 10)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 0, top: 20, bottom: 20, right: 20),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    textAlign: TextAlign.end,
                                    textDirection: TextDirection.ltr,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'(^\d*\.?\d{0,2})'))
                                    ],
                                    controller: companyFaxController.value,
                                    validator:
                                        ValidationBuilder().phone().build(),
                                    decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                            borderSide: BorderSide(width: 1)),
                                        labelText: "الفاكس".tr,
                                        isCollapsed: true,
                                        contentPadding: const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: 10,
                                            bottom: 10)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, top: 20, bottom: 20, right: 20),
                                child: Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: TextFormField(
                                    controller: companyEmailController.value,
                                    validator: ValidationBuilder()
                                        .minLength(3)
                                        .build(),
                                    decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                            borderSide: BorderSide(width: 1)),
                                        labelText: "الاميل".tr,
                                        isCollapsed: true,
                                        contentPadding: const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: 10,
                                            bottom: 10)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, top: 20, bottom: 20, right: 20),
                                child: Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: TextFormField(
                                    controller: companyFacebookController.value,
                                    validator: ValidationBuilder()
                                        .minLength(3)
                                        .build(),
                                    decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                            borderSide: BorderSide(width: 1)),
                                        labelText: "صفحة الفايسبوك".tr,
                                        isCollapsed: true,
                                        contentPadding: const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: 10,
                                            bottom: 10)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                onPressed: () async {
                                  var ccompany = company.value;
                                  ccompany.companyName =
                                      companyNameController.value.text;
                                  ccompany.telephone =
                                      companyTelephoneController.value.text;
                                  ccompany.fix =
                                      companyFixController.value.text;
                                  ccompany.fax =
                                      companyFaxController.value.text;
                                  ccompany.faceBook =
                                      companyFacebookController.value.text;
                                  ccompany.whatsapp =
                                      companyWahtsappController.value.text;
                                  ccompany.email =
                                      companyEmailController.value.text;
                                  companyData.updateCompany(ccompany);
                                  await getCompanySettings();
                                  Get.back();
                                },
                                child: Text("حفظ التعديل".tr)),
                          )),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text("الغاء التعديل".tr)),
                          ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ));
  }

  showCompanyAboutSettiong() {
    showDialog(
        context: Get.context!,
        builder: (_) => Dialog(
              child: Form(
                key: form,
                child: SizedBox(
                  width: 400,
                  height: 500,
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, top: 20, bottom: 20, right: 20),
                                child: Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: TextFormField(
                                    controller: companyAboutController.value,
                                    validator: ValidationBuilder()
                                        .minLength(3)
                                        .build(),
                                    decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                            borderSide: BorderSide(width: 1)),
                                        labelText: "حول".tr,
                                        isCollapsed: true,
                                        contentPadding: const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: 10,
                                            bottom: 10)),
                                    maxLines: null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                onPressed: () async {
                                  company.value.about =
                                      companyAboutController.value.text;

                                  companyData.updateCompany(company.value);
                                  await getCompanySettings();
                                  Get.back();
                                },
                                child: Text("حفظ التعديل".tr)),
                          )),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text("الغاء التعديل".tr)),
                          ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ));
  }

  Stream<List<LigneCmd>> initDataCmd() async* {
    ligneCmdB.clear();

    customersU.listen((p0) {});
    for (var element in customersU) {
      for (var e
          in element.cartData!.where((element) => element.livred == true)) {
        ligneCmdB.addAll(e.cart!);
      }
    }

    x.value = cartProducts(ligneCmdB).take(10).toList();

    x.sort((a, b) => a.qte!.compareTo(b.qte!));
    if (x.isNotEmpty) {
      maxQte.value = x.last.qte!;
    }
    yield x;
  }

  Stream<List<LigneCmd>> initDataCmdEarning() async* {
    ligneCmdB.clear();
    customersU.listen((p0) {});
    for (var element in customersU) {
      for (var e
          in element.cartData!.where((element) => element.livred == true)) {
        ligneCmdB.addAll(e.cart!);
      }
    }

    x.value = cartProductsEarnig(ligneCmdB).take(10).toList();

    x.sort((a, b) => a.qte!.compareTo(b.qte!));
    if (x.isNotEmpty) {
      maxQte.value = x.last.qte!;
    }
    yield x;
  }

  showCompanyUserSettings() {
    showDialog(
        context: Get.context!,
        builder: (_) {
          return Dialog(
            child: SizedBox(
              width: 400,
              height: 500,
              child: Form(
                key: form,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.key,
                      color: BrandColors.alpamareBlue,
                      size: 70,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, top: 20, bottom: 20, right: 20),
                      child: Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: TextFormField(
                          onChanged: (e) {},
                          controller: adminUserController.value,
                          validator: ValidationBuilder().minLength(3).build(),
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(width: 1)),
                              labelText: "اسم المستخدم".tr,
                              isCollapsed: true,
                              contentPadding: const EdgeInsets.only(
                                  left: 15, right: 15, top: 10, bottom: 10)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, top: 20, bottom: 20, right: 20),
                      child: Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: TextFormField(
                          onChanged: (e) {},
                          controller: adminPwdController.value,
                          validator: ValidationBuilder().minLength(3).build(),
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(width: 1)),
                              labelText: "رمز الدخول".tr,
                              isCollapsed: true,
                              contentPadding: const EdgeInsets.only(
                                  left: 15, right: 15, top: 10, bottom: 10)),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          company.value.user =
                                              adminUserController.value.text;
                                          company.value.pwd = generateMd5(
                                              adminPwdController.value.text);

                                          companyData
                                              .updateCompany(company.value);
                                          await getCompanySettings();
                                          Get.back();
                                        },
                                        child: Text("حفظ التعديل".tr)),
                                  )),
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Text("الغاء التعديل".tr)),
                                  ))
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}




/**  await cmdo.value
        .readProductInCMD(
             currentCustomer.value, Commandes(key: cmdIDOP.value))
        .then((value) {
      cmdsUser.value = cartProducts(value);
      return badgeQte.value = cmdsUser.length.toDouble(); */