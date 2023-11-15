import 'dart:convert';

import 'package:async_button/async_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_validator/form_validator.dart';

import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../data/colors.dart';
import '../../../../models/product.dart';
import '../../../../utilities/data_converter.dart';
import '../../../../widgets/loading.dart';
import '../controllers/productmanagement_controller.dart';

class ProductManagementView extends StatefulWidget {
  ProductManagementView({Key? key}) : super(key: key);

  @override
  State<ProductManagementView> createState() => _ProductManagementViewState();
}

class _ProductManagementViewState extends State<ProductManagementView> {
  final cnt = Get.put(ProductmanagementController());

  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (cnt.onLoad.value) {
        return const Center(
          child: Loading(),
        );
      } else {
        if (cnt.error.value) {
          return Center(
            child: Text("Error".tr),
          );
        } else {
          return SizedBox(
            height: Get.height - 50,
            child: Column(children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () async {
                          if (cnt.categories.isNotEmpty) {
                            cnt.ddInitialValue.value = cnt.categories[0].key!;
                          }
                          cnt.isEdit.value = false;

                          cnt.itemNameController.value.text = '';
                          cnt.itemDetail.value.text = '';
                          cnt.itemPriceController.value.text = 0.toString();
                          cnt.itemSalesPrice.value.text = 0.toString();

                          cnt.isItemInSale.value = false;
                          await showDialog(
                              context: context,
                              builder: (_) => Dialog(
                                    child: SizedBox(
                                      height: Get.height * .9,
                                      width: Get.width * .8,
                                      child: Form(
                                        key: _form,
                                        child: Column(
                                          children: [
                                            Expanded(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: InkWell(
                                                        onTap: () async {
                                                          await cnt
                                                              .uploadFile();
                                                          Get.appUpdate();
                                                        },
                                                        child: cnt
                                                                .productUploadedImage
                                                                .value
                                                                .isEmpty
                                                            ? Icon(Icons.image,
                                                                size: 120,
                                                                color: BrandColors
                                                                    .gpColorRedHi)
                                                            : Image.memory(
                                                                cnt.productUploadedImage
                                                                    .value,
                                                                height: 150,
                                                                width: 150,
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20,
                                                              top: 20,
                                                              bottom: 20,
                                                              right: 20),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(7.0),
                                                        child: TextFormField(
                                                          enabled: false,
                                                          controller:
                                                              cnt.itemKey.value,
                                                          validator:
                                                              ValidationBuilder()
                                                                  .minLength(3)
                                                                  .build(),
                                                          decoration: InputDecoration(
                                                              border: const OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          width:
                                                                              1)),
                                                              labelText:
                                                                  "مفتاح المنتج"
                                                                      .tr,
                                                              isCollapsed: true,
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 15,
                                                                      right: 15,
                                                                      top: 10,
                                                                      bottom:
                                                                          10)),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20,
                                                              top: 1,
                                                              bottom: 1,
                                                              right: 20),
                                                      child:
                                                          cnt.categories
                                                                  .isNotEmpty
                                                              ? SizedBox(
                                                                  height: 50,
                                                                  child:
                                                                      DropdownButtonHideUnderline(
                                                                    child:
                                                                        GFDropdown(
                                                                      itemHeight:
                                                                          50,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      border: const BorderSide(
                                                                          color: Colors
                                                                              .black12,
                                                                          width:
                                                                              1),
                                                                      dropdownButtonColor:
                                                                          Colors
                                                                              .grey[300],
                                                                      value: cnt
                                                                          .ddInitialValue
                                                                          .value,
                                                                      onChanged:
                                                                          (newValue) {
                                                                        cnt.ddInitialValue.value =
                                                                            newValue!;
                                                                        Get.appUpdate();
                                                                      },
                                                                      items: cnt
                                                                          .categories
                                                                          .map((value) =>
                                                                              DropdownMenuItem(
                                                                                value: value.key,
                                                                                child: SizedBox(height: 50, width: Get.width - 400, child: Text(value.categoryName!)),
                                                                              ))
                                                                          .toList(),
                                                                    ),
                                                                  ),
                                                                )
                                                              : Container(),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20,
                                                              top: 20,
                                                              bottom: 20,
                                                              right: 20),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(7.0),
                                                        child: TextFormField(
                                                          onChanged: (e) {
                                                            var bytes =
                                                                utf8.encode(e);

                                                            cnt.itemKey.value
                                                                    .text =
                                                                base64.encode(
                                                                    bytes);
                                                          },
                                                          controller: cnt
                                                              .itemNameController
                                                              .value,
                                                          validator:
                                                              ValidationBuilder()
                                                                  .minLength(3)
                                                                  .build(),
                                                          decoration: InputDecoration(
                                                              border: const OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          width:
                                                                              1)),
                                                              labelText:
                                                                  "المنتج".tr,
                                                              isCollapsed: true,
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 15,
                                                                      right: 15,
                                                                      top: 10,
                                                                      bottom:
                                                                          10)),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20,
                                                              top: 20,
                                                              bottom: 20,
                                                              right: 20),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(7.0),
                                                        child: TextFormField(
                                                          controller: cnt
                                                              .itemDetail.value,
                                                          validator:
                                                              ValidationBuilder()
                                                                  .minLength(3)
                                                                  .build(),
                                                          decoration: InputDecoration(
                                                              border: const OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          width:
                                                                              1)),
                                                              labelText:
                                                                  "وصف المنتج"
                                                                      .tr,
                                                              isCollapsed: true,
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 15,
                                                                      right: 15,
                                                                      top: 10,
                                                                      bottom:
                                                                          10)),
                                                          maxLines: null,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20,
                                                              top: 20,
                                                              bottom: 20,
                                                              right: 20),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(7.0),
                                                        child: TextFormField(
                                                          onChanged: (e) {},
                                                          controller: cnt
                                                              .itemUnit.value,
                                                          validator:
                                                              ValidationBuilder()
                                                                  .minLength(3)
                                                                  .build(),
                                                          decoration: InputDecoration(
                                                              border: const OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          width:
                                                                              1)),
                                                              labelText:
                                                                  "الوحدة".tr,
                                                              isCollapsed: true,
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 15,
                                                                      right: 15,
                                                                      top: 10,
                                                                      bottom:
                                                                          10)),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20,
                                                              top: 20,
                                                              bottom: 20,
                                                              right: 20),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: TextFormField(
                                                          textAlign:
                                                              TextAlign.end,
                                                          textDirection:
                                                              TextDirection.ltr,
                                                          controller: cnt
                                                              .itemPriceController
                                                              .value,
                                                          validator:
                                                              ValidationBuilder()
                                                                  .minLength(1)
                                                                  .build(),
                                                          inputFormatters: <TextInputFormatter>[
                                                            FilteringTextInputFormatter
                                                                .allow(RegExp(
                                                                    r'(^\d*\.?\d{0,2})'))
                                                          ],
                                                          decoration: InputDecoration(
                                                              suffixText:
                                                                  'درهم',
                                                              border: const OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          width:
                                                                              1)),
                                                              labelText:
                                                                  "ثمن المنتج"
                                                                      .tr,
                                                              isCollapsed: true,
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 15,
                                                                      right: 15,
                                                                      top: 10,
                                                                      bottom:
                                                                          10)),
                                                        ),
                                                      ),
                                                    ),
                                                    Row(children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Directionality(
                                                            textDirection:
                                                                TextDirection
                                                                    .ltr,
                                                            child: Text(
                                                              cnt.visibiltyCaption,
                                                              style: TextStyle(
                                                                fontFamily: GoogleFonts.cairo(
                                                                        fontSize:
                                                                            18)
                                                                    .fontFamily,
                                                              ),
                                                            )),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Checkbox(
                                                            value: cnt
                                                                .itemVisibility
                                                                .value,
                                                            onChanged: (e) {
                                                              cnt.itemVisibility
                                                                  .value = e!;
                                                              Get.appUpdate();
                                                            }),
                                                      ),
                                                    ]),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20,
                                                              top: 20,
                                                              bottom: 20,
                                                              right: 20),
                                                      child: Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child:
                                                                Directionality(
                                                                    textDirection:
                                                                        TextDirection
                                                                            .ltr,
                                                                    child: Text(
                                                                      "التخفيض",
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            GoogleFonts.cairo(fontSize: 18).fontFamily,
                                                                      ),
                                                                    )),
                                                          ),
                                                          Checkbox(
                                                              value: cnt
                                                                  .isItemInSale
                                                                  .value,
                                                              onChanged: (e) {
                                                                cnt.isItemInSale
                                                                    .value = e!;
                                                                Get.appUpdate();
                                                              }),
                                                          Expanded(
                                                            child: !cnt
                                                                    .isItemInSale
                                                                    .value
                                                                ? Container()
                                                                : Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left: 0,
                                                                        top: 20,
                                                                        bottom:
                                                                            20,
                                                                        right:
                                                                            20),
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          TextFormField(
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                        textDirection:
                                                                            TextDirection.ltr,
                                                                        keyboardType:
                                                                            TextInputType.number,
                                                                        inputFormatters: <TextInputFormatter>[
                                                                          FilteringTextInputFormatter.allow(
                                                                              RegExp(r'(^\d*\.?\d{0,2})'))
                                                                        ],
                                                                        controller: cnt
                                                                            .itemSalesPrice
                                                                            .value,
                                                                        validator: ValidationBuilder()
                                                                            .minLength(1)
                                                                            .build(),
                                                                        decoration: InputDecoration(
                                                                            suffixText:
                                                                                'درهم',
                                                                            border:
                                                                                const OutlineInputBorder(borderSide: BorderSide(width: 1)),
                                                                            labelText: "ثمن تخفيض المنتج".tr,
                                                                            isCollapsed: true,
                                                                            contentPadding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10)),
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
                                                  left: 20,
                                                  top: 20,
                                                  bottom: 20,
                                                  right: 20),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Expanded(
                                                    child: SizedBox(
                                                      height: 40,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 20,
                                                                right: 20),
                                                        child:!cnt.toFinishSuccessfully.value ?const Center(child: SizedBox(height: 40,width: 40,child: CircularProgressIndicator(),)):   ElevatedButton(
                                                           
                                                                onPressed: !cnt
                                                                        .imageUploaded
                                                                        .value
                                                                    ? null
                                                                    : () async {
                                                                        cnt.toFinishSuccessfully.value =
                                                                            false;
                                                                        Get.appUpdate();
                                                                        try {
                                                                         
                                                                          if (_form
                                                                              .currentState!
                                                                              .validate()) {
                                                                            await cnt.uploadImageToStorage();
                                                                            cnt.item.value.img !=
                                                                                cnt.productUploadedImagePath.value;
                                                                            var ppro = Product(
                                                                                img: cnt.productUploadedImagePath.value,
                                                                                key: cnt.itemKey.value.text,
                                                                                productName: cnt.itemNameController.value.text,
                                                                                isSale: cnt.isItemInSale.value,
                                                                                nPrice: double.tryParse(cnt.itemPriceController.value.text),
                                                                                sPrice: double.tryParse(cnt.itemSalesPrice.value.text),
                                                                                categorie: cnt.ddInitialValue.value,
                                                                                visiblity: cnt.itemVisibility.value,
                                                                                unit: cnt.itemUnit.value.text);
                                                                            //  print('key:${ppro.key}      \nimg: ${ppro.img} \nprName: ${ppro.productName}\nprsales: ${ppro.isSale} \nnPrice: ${ppro.nPrice}\nsPrice: ${ppro.sPrice}\ncategorie: ${ppro.categorie}  \nvisiblity: ${ppro.visiblity}');
                                                                            cnt.productData.create(ppro);
                                                                          cnt.onInit();
                                                                            Get.back();
                                                                          }
                                                                        } catch (e) {
                                                                          
                                                                        }

                                                                         cnt.toFinishSuccessfully.value =false ;
 Get.appUpdate();
                                                                      },
                                                                child:
                                                                    const Text(
                                                                  "تاكيد",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
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
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 20,
                                                                right: 20),
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      BrandColors
                                                                          .googleRed),
                                                          onPressed: () async {
                                                            Get.back();
                                                          },
                                                          child: Text(
                                                            "الغاء",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: BrandColors
                                                                    .kPrimaryColor),
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
                        },
                        child: const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.add),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("اضافة منتج"),
                            ),
                          ],
                        )),
                  ),
                  Expanded(
                      child: TextField(
                    controller: cnt.searchController.value,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(width: 1)),
                        labelText: "ادخل كلمة البحث . . .".tr,
                        isCollapsed: true,
                        contentPadding: const EdgeInsets.only(
                            left: 15, right: 15, top: 10, bottom: 10)),
                  )),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: ElevatedButton.icon(
                        onPressed: () {
                          cnt.products.value = cnt.filterProducts
                              .where((element) => element.productName!
                                  .contains(cnt.searchController.value.text))
                              .toList();

                          setState(() {});
                        },
                        icon: const Icon(Icons.search),
                        label: const Text("بحث ")),
                  )
              
              ,
                ElevatedButton(
                        onPressed: () async {},child:const Text("اضافة متغير للشراء"))
                ],
              ),
              Expanded(
                  child: _StoreTable(
                items: cnt.products,
                onVisible: (e) {
                  cnt.itemVisibility.value = e;
                },
                onUpdate: (Product cus) async {
                  cnt.isEdit.value = true;
                  try {
                    await cnt.networkImageToBase64OnEdit(cus.img!);
                    cnt.productUploadedImagePath.value = cus.img!;
                    cnt.itemKey.value.text = cus.key!;
                    cnt.ddInitialValue.value = cus.categorie!;
                    cnt.item.value.img != cnt.productUploadedImagePath.value;
                    cnt.itemNameController.value.text = cus.productName!;
                    cnt.itemDetail.value.text = cus.productName!;
                    cnt.itemPriceController.value.text = cus.nPrice!.toString();
                    cnt.itemSalesPrice.value.text = cus.sPrice!.toString();
                    cnt.isItemInSale.value = cus.isSale!;
                    cnt.itemUnit.value.text = cus.unit!.toString();

                    await cnt.showProductManagementDialog();
                  } catch (e) {}
                },
              ))
            ]),
          );
        }
      }
    });
  }
}

class _StoreTable extends StatelessWidget {
  final void Function(Product cus) onUpdate;
  final void Function(bool cus) onVisible;
  const _StoreTable(
      {required this.items, required this.onUpdate, required this.onVisible});
  final List<Product> items;

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      //  onQueryRowHeight: (details) {
      //   return details.getIntrinsicRowHeight(details.rowIndex);
      // },
      source: _ItemsDataSource(
        (currentCustomer) => onUpdate(currentCustomer),
        items: items,
        onVisible: (visible) => onVisible(visible),
      ),
      columnWidthMode: ColumnWidthMode.fill,
      columns: <GridColumn>[
        GridColumn(
            columnName: 'ARTICLE',
            label: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text(
                  'المنتج',
                  style: GoogleFonts.cairo(),
                ))),
        GridColumn(
            columnName: 'IMG',
            label: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text(
                  'الصورة',
                  style: GoogleFonts.cairo(),
                ))),
        GridColumn(
            columnName: 'P.U.',
            label: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text(
                  "ثمن البيع",
                  style: GoogleFonts.cairo(),
                ))),
        GridColumn(
            columnName: 'S.P.U.',
            label: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text(
                  "ثمن التخفيض",
                  style: GoogleFonts.cairo(),
                ))),
        GridColumn(
            columnName: 'VISIBILTY',
            label: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text(
                  'نشر',
                  style: GoogleFonts.cairo(),
                ))),
        GridColumn(
            columnName: 'MODIFIER',
            label: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text(
                  'تعديل',
                  style: GoogleFonts.cairo(),
                ))),
      ],
    );
  }
}

class _ItemsDataSource extends DataGridSource {
  final void Function(Product cus) onUpdate;
  final void Function(bool cus) onVisible;
  _ItemsDataSource(
    this.onUpdate, {
    required List<Product> items,
    required this.onVisible,
  }) {
    _items = items
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: "ARTICLE", value: e.productName),
              DataGridCell<String>(columnName: "IMG", value: e.img),
              DataGridCell<String>(
                  columnName: "P.U.",
                  value: DataConverter.currencyConvert(e.nPrice!)),
              // DataGridCell<double>(columnName: "P.U.", value: e.oPrice),
              DataGridCell<double>(columnName: "S.P.U.", value: e.sPrice),
              //
              DataGridCell<Product>(columnName: "VISIBILTY", value: e),
              DataGridCell<Product>(columnName: "MODIFIER", value: e),
            ]))
        .toList();
  }

  List<DataGridRow> _items = [];

  @override
  List<DataGridRow> get rows => _items;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      if (e.columnName == "MODIFIER") {
        return Padding(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: ElevatedButton(
              onPressed: () => onUpdate(e.value),
              child: const Center(
                child: Icon(
                  Icons.edit,
                  size: 14,
                ),
              ),
            ),
          ),
        );
      } else if (e.columnName == 'IMG') {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(
            e.value,
            width: 30,
            height: 30,
            fit: BoxFit.contain,
          ),
        );
      } else if (e.columnName == "VISIBILTY") {
        return SizedBox(
          height: 50,
          child: Center(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
              child: Checkbox(
                value: e.value.visiblity as bool,
                onChanged: (bool? value) => onVisible(value!),
              ),
            ),
          ),
        );
      } else {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(e.value.toString()),
        );
      }
    }).toList());
  }
}
