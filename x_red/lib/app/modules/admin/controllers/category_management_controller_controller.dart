// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:http/http.dart' as http;
import '../../../../data/colors.dart';
import '../../../../data/reposetory/categorie_data.dart';
import '../../../../data/reposetory/product_data.dart';
import '../../../../models/category.dart';
import '../../../../models/product.dart';

class CategoryManagementControllerController extends GetxController {
  Uint8List? noImage;
  final GlobalKey<FormState> form = GlobalKey<FormState>();
  final imageUploaded = true.obs;
  final imgStoragePath = ''.obs;
  var categoryUploadedImage = Uint8List(0).obs;
  var categoryUploadedImagePath = ''.obs;
  final catCrud = CategoriesData();
  final products = <Product>[].obs;
  final productData = ProductData();
  final onLoad = false.obs;
  final loaded = false.obs;
  final error = false.obs;
  final isEdit = false.obs;
    final searchController = TextEditingController().obs;
  final categoryNameController = TextEditingController().obs;
  final categoryKeyController = TextEditingController().obs;
  final category = Category().obs;
  
  final categories = <Category>[].obs;

  final allCategories = <Category>[].obs;
  @override
  void onInit() async {
    try {
      noImage =await networkImageToBase64();
      await catCrud.readCategories.then((values) {
        allCategories.value =values ;
        return categories.value = values;
      });
      await productData.readI().then((valuex) => products.value = valuex).whenComplete(() => print(products.length));
      categoryUploadedImage.value = await networkImageToBase64();
      onLoad.value = true;
      loaded.value = false;
      error.value = false;
    } catch (e) {
      onLoad.value = false;
      loaded.value = false;
      error.value = true;

    } finally {
      onLoad.value = false;
      loaded.value = true;
      error.value = false;
    }
    super.onInit();
  }

  Future<void> loadData() async {}

  Stream<List<Category>> get streamCategories async* {
    // catCrud.readCategory((){}).then((value) => categories.value = value);
  }

  uploadFile() async {
    await ImagePickerWeb.getImageAsBytes()
        .then((value) => categoryUploadedImage.value = value!);
  }

  

  Future<Uri?> _uploadFile(Uint8List image, String ref, String fileName) async {
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
      print('$e error');
      return null;
    }
  }

  Future<void> uploadImageToStorage() async {
    await _uploadFile(categoryUploadedImage.value, 'ImagesFiles',
            categoryKeyController.value.text)
        .then((value) => imgStoragePath.value = value.toString());
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
    } catch (e) {
      print(e);
    }
    return Uint8List(0);
  }

  Future<Uint8List?> assetsImageToBase64() async {
    try {
      final ByteData bytes = await rootBundle.load('images/logo.jpg');
      final Uint8List list = bytes.buffer.asUint8List();
      return list;
    } catch (e) {
      print(e);
      return Uint8List(0);
    }
  }

  Future<void> showEidtDialog() async {
    showDialog(
        context: Get.context!,
        builder: (_) {
          return Dialog(
            child: SizedBox(
              height: Get.height * .9,
              width: Get.width * .8,
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () async {
                              await uploadFile();
                              Get.appUpdate();
                            },
                            child: Image.memory(
                              categoryUploadedImage.value,
                              height: 150,
                              width: 150,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Form(
                              key: form,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      enabled: false,
                                      controller: categoryKeyController.value,
                                      validator: ValidationBuilder()
                                          .minLength(3)
                                          .maxLength(50)
                                          .build(),
                                      decoration: InputDecoration(
                                          border: const OutlineInputBorder(
                                              borderSide: BorderSide(width: 1)),
                                          labelText: "مفتاح الصنف".tr,
                                          isCollapsed: true,
                                          contentPadding: const EdgeInsets.only(
                                              left: 15,
                                              right: 15,
                                              top: 10,
                                              bottom: 10)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      onChanged: (e) {
                                        if(!isEdit.value){
                                              var bytes = utf8.encode(e);

                                        categoryKeyController.value.text =
                                            base64
                                                .encode(bytes)
                                                .replaceAll("/", '');
                                        }
                                    
                                      },
                                      controller: categoryNameController.value,
                                      validator: ValidationBuilder()
                                          .minLength(3)
                                          .maxLength(50)
                                          .build(),
                                      decoration: InputDecoration(
                                          border: const OutlineInputBorder(
                                              borderSide: BorderSide(width: 1)),
                                          labelText: "اسم الصنف".tr,
                                          isCollapsed: true,
                                          contentPadding: const EdgeInsets.only(
                                              left: 15,
                                              right: 15,
                                              top: 10,
                                              bottom: 10)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, top: 20, bottom: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: ElevatedButton(
                                onPressed: !imageUploaded.value
                                    ? null
                                    : () async {
                                        if (form.currentState!.validate()) {
                                          category.value.key =
                                              categoryKeyController.value.text
                                                  .replaceAll("/", '');
                                          category.value.categoryName =
                                              categoryNameController.value.text;

                                          await uploadImageToStorage();

                                          category.value.img =
                                              categoryUploadedImagePath.value;

                                          catCrud.create(category.value);

                                          categories.add(category.value);
                                          onInit();
                                          Get.back();
                                        }
                                      },
                                child: const Text(
                                  "تاكيد",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: BrandColors.googleRed),
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text(
                                  "الغاء",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: BrandColors.kPrimaryColor),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
