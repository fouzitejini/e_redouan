import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../data/colors.dart';
import '../../../../models/category.dart';
import '../../../../widgets/loading.dart';
import '../controllers/category_management_controller_controller.dart';

class CategoriesManagementView extends StatefulWidget {
  CategoriesManagementView({Key? key}) : super(key: key);

  @override
  State<CategoriesManagementView> createState() => _CategoriesManagementViewState();
}

class _CategoriesManagementViewState extends State<CategoriesManagementView> {
  final cnt = Get.put(CategoryManagementControllerController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (cnt.onLoad.value) {
        return const Loading();
      } else {
        if (cnt.error.value) {
          return Center(
            child: Text("Error".tr),
          );
        } else {
          return SizedBox(
            height: Get.height - 50,
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () async {
                            cnt.imgStoragePath.value = '';
                            cnt.categoryKeyController.value.text = '';
                            cnt.categoryNameController.value.text = '';
                            cnt.categoryUploadedImage.value = cnt.noImage!;
                            cnt.isEdit.value = false;
                            await showDialog(
                                context: context,
                                builder: (_) => Dialog(
                                      child: SizedBox(
                                        height: Get.height * .9,
                                        width: Get.width * .8,
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    InkWell(
                                                      onTap: () async {
                                                        await cnt.uploadFile();
                                                        Get.appUpdate();
                                                      },
                                                      child: Image.memory(
                                                        cnt.categoryUploadedImage
                                                            .value,
                                                        height: 150,
                                                        width: 150,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Form(
                                                        key: cnt.form,
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child:
                                                                  TextFormField(
                                                                enabled: false,
                                                                controller: cnt
                                                                    .categoryKeyController
                                                                    .value,
                                                                validator: ValidationBuilder()
                                                                    .minLength(
                                                                        3)
                                                                    .maxLength(
                                                                        50)
                                                                    .build(),
                                                                decoration: InputDecoration(
                                                                    border: const OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                            width:
                                                                                1)),
                                                                    labelText:
                                                                        "مفتاح الصنف"
                                                                            .tr,
                                                                    isCollapsed:
                                                                        true,
                                                                    contentPadding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            15,
                                                                        right:
                                                                            15,
                                                                        top: 10,
                                                                        bottom:
                                                                            10)),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child:
                                                                  TextFormField(
                                                                onChanged: (e) {
                                                                  if (!cnt
                                                                      .isEdit
                                                                      .value) {
                                                                    var bytes =
                                                                        utf8.encode(
                                                                            e);

                                                                    cnt.categoryKeyController.value.text = base64
                                                                        .encode(
                                                                            bytes)
                                                                        .replaceAll(
                                                                            "/",
                                                                            '');
                                                                  }
                                                                },
                                                                controller: cnt
                                                                    .categoryNameController
                                                                    .value,
                                                                validator: ValidationBuilder()
                                                                    .minLength(
                                                                        3)
                                                                    .maxLength(
                                                                        50)
                                                                    .build(),
                                                                decoration: InputDecoration(
                                                                    border: const OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                            width:
                                                                                1)),
                                                                    labelText:
                                                                        "اسم الصنف"
                                                                            .tr,
                                                                    isCollapsed:
                                                                        true,
                                                                    contentPadding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            15,
                                                                        right:
                                                                            15,
                                                                        top: 10,
                                                                        bottom:
                                                                            10)),
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
                                                        child: ElevatedButton(
                                                          onPressed:
                                                              !cnt.imageUploaded
                                                                      .value
                                                                  ? null
                                                                  : () async {
                                                                      if (cnt
                                                                          .form
                                                                          .currentState!
                                                                          .validate()) {
                                                                        if (!cnt
                                                                            .isEdit
                                                                            .value) {
                                                                          cnt.category.value.key = cnt
                                                                              .categoryKeyController
                                                                              .value
                                                                              .text
                                                                              .replaceAll("/", '');
                                                                          cnt.category.value.categoryName = cnt
                                                                              .categoryNameController
                                                                              .value
                                                                              .text;
                                                                          await cnt
                                                                              .uploadImageToStorage();
                                                                          cnt.category.value.img = cnt
                                                                              .categoryUploadedImagePath
                                                                              .value;

                                                                          cnt.catCrud.create(cnt
                                                                              .category
                                                                              .value);
                                                                        } else {
                                                                          await cnt
                                                                              .uploadImageToStorage();
                                                                          cnt.category.value.img = cnt
                                                                              .categoryUploadedImagePath
                                                                              .value;

                                                                          cnt.catCrud.update(cnt
                                                                              .category
                                                                              .value);
                                                                        }

                                                                        cnt.onInit();
                                                                        Get.back();
                                                                      }
                                                                    },
                                                          child: const Text(
                                                            "تاكيد",
                                                            style: TextStyle(
                                                                fontSize: 15,
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
                                            ),
                                          ],
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
                                child: Text("اضافة مجموعة"),
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
                            cnt.categories.value = cnt.allCategories
                                .where((element) => element.categoryName!
                                    .contains(cnt.searchController.value.text))
                                .toList();

                            setState(() {
                              
                            });
                          },
                          icon: const Icon(Icons.search),
                          label: const Text("بحث ")),
                    )
                  ],
                ),
                Expanded(
                    child: _StoreTable(
                  items: cnt.categories,
                  onDelete: (cat) async {
                    await cnt.catCrud.delete(
                      cat,
                    );

                    cnt.onInit();
                  },
                  onEdit: (cat) async {
                    cnt.isEdit.value = true;
                    cnt.imgStoragePath.value = cat.img!;
                    cnt.categoryKeyController.value.text = cat.key!;
                    cnt.categoryNameController.value.text = cat.categoryName!;
                    cnt.categoryUploadedImage.value =
                        await cnt.networkImageToBase64OnEdit(cat.img!);
                    await cnt.showEidtDialog();
                    // cnt.categoryUploadedImage.value =
                    //  await cnt.convertImageToBase64(cat.img!);
                  },
                )),
              ],
            ),
          );
        }
      }
    });
  }
}

class _StoreTable extends StatelessWidget {
  final void Function(Category cat) onDelete;

  final void Function(Category cat) onEdit;
  const _StoreTable(
      {required this.items, required this.onDelete, required this.onEdit});
  final List<Category> items;

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      footer: const Center(child: Text("")),
      onQueryRowHeight: (details) {
        return details.rowHeight;
        //(details.rowIndex)
      },
      source: _ItemsDataSource((cat) => onDelete(cat), (cat) => onEdit(cat),
          items: items),
      columnWidthMode: ColumnWidthMode.fill,
      columns: <GridColumn>[
        GridColumn(
            columnName: 'CATEGORY',
            label: Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.center,
                child: Text('المجموعة', style: GoogleFonts.cairo()))),
        GridColumn(
            columnName: 'IMG',
            label: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text('الصورة', style: GoogleFonts.cairo()))),
        GridColumn(
            columnName: 'SUPPRIMER',
            label: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text('حذف', style: GoogleFonts.cairo()))),
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
  final void Function(Category cat) onDelete;

  final void Function(Category cat) onEdit;
  _ItemsDataSource(
    this.onDelete,
    this.onEdit, {
    required List<Category> items,
  }) {
    _items = items
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(
                  columnName: "CATEGORY", value: e.categoryName),
              DataGridCell<String>(columnName: "IMG", value: e.img),
              DataGridCell<Category>(columnName: "SUPPRIMER", value: e),
              DataGridCell<Category>(columnName: "MODIFIER", value: e),
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
            child: ElevatedButton(
              onPressed: () => onEdit(e.value),
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.green[400]),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Icon(
                    Icons.edit,
                    color: Colors.white54,
                    size: 20,
                  ),
                ),
              ),
            ));
      } else if (e.columnName == "SUPPRIMER") {
        return Padding(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
            child: ElevatedButton(
              onPressed: () => onDelete(e.value as Category),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red[200]),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.delete,
                  color: Colors.white54,
                  size: 20,
                ),
              ),
            ));
      } else if (e.columnName == 'IMG') {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(
            e.value,
            width: 30,
            height: 30,
            fit: BoxFit.fitHeight,
          ),
        );
      } else {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(e.value.toString(), style: GoogleFonts.cairo()),
        );
      }
    }).toList());
  }
}
