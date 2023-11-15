// ignore_for_file: depend_on_referenced_packages

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker_web/image_picker_web.dart';
import '../../../../data/colors.dart';
import '../../../../data/reposetory/product_data.dart';
import '../../../../models/category.dart';
import '../../../../models/product.dart';
import 'category_management_controller_controller.dart';
import 'package:async_button/async_button.dart';
class ProductmanagementController extends GetxController {
  final categories =
      Get.find<CategoryManagementControllerController>().categories;
  final productData = ProductData();
  final ddInitialValue = ''.obs;
  final onLoad = false.obs;
  final loaded = false.obs;
  final error = false.obs;
  final items = <Product>[].obs;
  final itemVisibility = true.obs;
  final toFinishSuccessfully = true.obs;
  AsyncBtnStatesController elevatedBtnController = AsyncBtnStatesController();
  AsyncBtnStatesController outlinedBtnController = AsyncBtnStatesController();
  AsyncBtnStatesController textBtnController = AsyncBtnStatesController();
  final visibiltyCaption = 'نشر';
  final GlobalKey<FormState> form = GlobalKey<FormState>();
  final isEdit = false.obs;
  final item = Product().obs;
  final itemNameController = TextEditingController().obs;
  final itemPriceController = TextEditingController().obs;
  final itemSalesPriceController = TextEditingController().obs;
  final itemPurchaseUnit = TextEditingController().obs;
  final itemInitialQte = TextEditingController().obs;
  final itemSalesPrice = TextEditingController().obs;
  final itemUnit = TextEditingController().obs;
  final isItemInSale = false.obs;
  final itemKey = TextEditingController().obs;
  final itemDetail = TextEditingController().obs;
  final itemPrice = TextEditingController().obs;
  final products = <Product>[].obs;
  final filterProducts = <Product>[].obs;
  final allProducts = <Product>[].obs;
  var productUploadedImage = Uint8List(0).obs;
  final imgStoragePath = ''.obs;
  var productUploadedImagePath = ''.obs;
  final imageUploaded = true.obs;
  final searchController = TextEditingController().obs;
  @override
  void onInit() async {
    try {
      await productData.readI().then((value) {
        if (searchController.value.text.replaceAll(' ', '').isNotEmpty) {
          filterProducts.value = value
              .where((element) =>
                  element.productName ==
                  searchController.value.text.replaceAll(' ', ''))
              .toList();

          products.value = filterProducts;
        } else {
          filterProducts.value = value;
          products.value = filterProducts;
        }
        return products;
      });
      productUploadedImage.value = await networkImageToBase64();
      itemNameController.value.text = '';
      itemPriceController.value.text = 0.toString();
      itemSalesPrice.value.text = 0.toString();
      onLoad.value = true;
      loaded.value = false;
      error.value = false;
    } catch (e) {
      onLoad.value = false;
      loaded.value = false;
      error.value = true;

      return;
    } finally {
      onLoad.value = false;
      loaded.value = true;
      error.value = false;
    }
    super.onInit();
  }

  Future<void> loadData() async {}

  delete(String c, Product p) {
    //prodCrud.delete(c, p);
  }

  uploadFile() async {
    productUploadedImage.value = (await ImagePickerWeb.getImageAsBytes())!;
  }

  Future<String?> get getImage async {
    var result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      return result.paths.first!;
    }
    return null;
  }

  Future<void> saveImage() async {}

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
      productUploadedImagePath.value = downloadURL;

      return Uri.parse(downloadURL);
    } catch (e) {
      return null;
    }
  }

  Future<void> uploadImageToStorage() async {
    await _uploadFile(
            productUploadedImage.value, 'ImagesFiles', itemKey.value.text)
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
      http.Response response = await http.get(Uri.parse(path));
      final bytes = response.bodyBytes;
      productUploadedImage.value = bytes;
      return bytes;
    } catch (e) {
      print(e);
    }
    return Uint8List(0);
  }

  showProductManagementDialog() async {
    await showDialog(
        context: Get.context!,
        builder: (_) => Dialog(
              child: SizedBox(
                height: Get.height * .9,
                width: Get.width * .8,
                child: Form(
                  key: form,
                  child: Column(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () async {
                                    await uploadFile();
                                    Get.appUpdate();
                                  },
                                  child: productUploadedImage.value.isEmpty
                                      ? Icon(Icons.image,
                                          size: 120,
                                          color: BrandColors.gpColorRedHi)
                                      : Image.memory(
                                          productUploadedImage.value,
                                          height: 150,
                                          width: 150,
                                          fit: BoxFit.fill,
                                        ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, top: 20, bottom: 20, right: 20),
                                child: Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: TextFormField(
                                    enabled: false,
                                    controller: itemKey.value,
                                    validator: ValidationBuilder()
                                        .minLength(3)
                                        .build(),
                                    decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                            borderSide: BorderSide(width: 1)),
                                        labelText: "مفتاح المنتج".tr,
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
                                    left: 20, top: 1, bottom: 1, right: 20),
                                child: categories.isNotEmpty
                                    ? SizedBox(
                                        height: 50,
                                        child: DropdownButtonHideUnderline(
                                          child: GFDropdown(
                                            itemHeight: 50,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: const BorderSide(
                                                color: Colors.black12,
                                                width: 1),
                                            dropdownButtonColor:
                                                Colors.grey[300],
                                            value: ddInitialValue.value,
                                            onChanged: (newValue) {
                                              ddInitialValue.value = newValue!;
                                              Get.appUpdate();
                                            },
                                            items: categories
                                                .map(
                                                    (value) => DropdownMenuItem(
                                                          value: value.key,
                                                          child: SizedBox(
                                                              height: 50,
                                                              width: Get.width -
                                                                  400,
                                                              child: Text(value
                                                                  .categoryName!)),
                                                        ))
                                                .toList(),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, top: 20, bottom: 20, right: 20),
                                child: Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: TextFormField(
                                    onChanged: (e) {},
                                    controller: itemNameController.value,
                                    validator: ValidationBuilder()
                                        .minLength(3)
                                        .build(),
                                    decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                            borderSide: BorderSide(width: 1)),
                                        labelText: "المنتج".tr,
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
                                    controller: itemDetail.value,
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
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, top: 20, bottom: 20, right: 20),
                                child: Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: TextFormField(
                                    onChanged: (e) {},
                                    controller: itemUnit.value,
                                    validator: ValidationBuilder()
                                        .minLength(3)
                                        .build(),
                                    decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                            borderSide: BorderSide(width: 1)),
                                        labelText: "الوحدة".tr,
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    textAlign: TextAlign.end,
                                    textDirection: TextDirection.ltr,
                                    controller: itemPriceController.value,
                                    validator: ValidationBuilder()
                                        .minLength(1)
                                        .build(),
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'(^\d*\.?\d{0,2})'))
                                    ],
                                    decoration: InputDecoration(
                                        suffixText: 'درهم',
                                        border: const OutlineInputBorder(
                                            borderSide: BorderSide(width: 1)),
                                        labelText: "ثمن المنتج".tr,
                                        isCollapsed: true,
                                        contentPadding: const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: 10,
                                            bottom: 10)),
                                  ),
                                ),
                              ),
                              Row(children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: Text(
                                        visibiltyCaption,
                                        style: TextStyle(
                                          fontFamily:
                                              GoogleFonts.cairo(fontSize: 18)
                                                  .fontFamily,
                                        ),
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Checkbox(
                                      value: itemVisibility.value,
                                      onChanged: (e) {
                                        itemVisibility.value = e!;
                                        Get.appUpdate();
                                      }),
                                ),
                              ]),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, top: 20, bottom: 20, right: 20),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Directionality(
                                          textDirection: TextDirection.ltr,
                                          child: Text(
                                            "التخفيض",
                                            style: TextStyle(
                                              fontFamily: GoogleFonts.cairo(
                                                      fontSize: 18)
                                                  .fontFamily,
                                            ),
                                          )),
                                    ),
                                    Checkbox(
                                        value: isItemInSale.value,
                                        onChanged: (e) {
                                          isItemInSale.value = e!;
                                          Get.appUpdate();
                                        }),
                                    Expanded(
                                      child: !isItemInSale.value
                                          ? Container()
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 0,
                                                  top: 20,
                                                  bottom: 20,
                                                  right: 20),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: TextFormField(
                                                  textAlign: TextAlign.end,
                                                  textDirection:
                                                      TextDirection.ltr,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: <TextInputFormatter>[
                                                    FilteringTextInputFormatter
                                                        .allow(RegExp(
                                                            r'(^\d*\.?\d{0,2})'))
                                                  ],
                                                  controller:
                                                      itemSalesPrice.value,
                                                  validator: ValidationBuilder()
                                                      .minLength(1)
                                                      .build(),
                                                  decoration: InputDecoration(
                                                      suffixText: 'درهم',
                                                      border: const OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  width: 1)),
                                                      labelText:
                                                          "ثمن تخفيض المنتج".tr,
                                                      isCollapsed: true,
                                                      contentPadding:
                                                          const EdgeInsets.only(
                                                              left: 15,
                                                              right: 15,
                                                              top: 10,
                                                              bottom: 10)),
                                                ),
                                              ),
                                            ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
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
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child:!toFinishSuccessfully.value ?const Center(child: SizedBox(height: 40,width: 40,child: CircularProgressIndicator(),)): ElevatedButton(
                                                              
                                                              
                                    onPressed: !imageUploaded.value
                                        ? null
                                        : () async {
                                                                                      toFinishSuccessfully.value =false ;
 Get.appUpdate();
          
                                          try {
                                              if (form.currentState!.validate()) {
                                              await uploadImageToStorage();
                                              var ppro = Product(
                                                  img: productUploadedImagePath
                                                      .value,
                                                  key: itemKey.value.text,
                                                  productName:
                                                      itemNameController
                                                          .value.text,
                                                  isSale: isItemInSale.value,
                                                  nPrice: double.tryParse(
                                                      itemPriceController
                                                          .value.text),
                                                  sPrice: double.tryParse(
                                                      itemSalesPrice
                                                          .value.text),
                                                  categorie:
                                                      ddInitialValue.value,
                                                  unit: itemUnit.value.text,
                                                  visiblity:
                                                      itemVisibility.value);

                                              productData.update(ppro, ppro);
                                              Get.back();
                                              onInit();
                                            }
                                          } catch (e) {
                                              
                                          }
                                      
                                        toFinishSuccessfully.value =true ;
 Get.appUpdate();
          
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
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: BrandColors.googleRed),
                                    onPressed: () async {
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
                      )
                    ],
                  ),
                ),
              ),
            ));
  }
}
