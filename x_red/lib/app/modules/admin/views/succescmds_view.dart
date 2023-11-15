import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redouanstore/utilities/sum.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../data/colors.dart';
import '../../../../models/customers.dart';
import '../../../../utilities/data_converter.dart';
import '../../../../widgets/loading.dart';
import '../controllers/admin_controller.dart';

class CustomerSuccesView extends StatefulWidget {
  const CustomerSuccesView({super.key});

  @override
  State<CustomerSuccesView> createState() =>
      _CustomerSuccesViewState();
}

class _CustomerSuccesViewState extends State<CustomerSuccesView> {
  final cnt = Get.put(AdminController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (cnt.loaded.value) {
        cnt.getCustomerHasCmdConfirmed.listen((event) {
          cnt.customersHasCmd.value = event;
        });
        return StreamBuilder<List<Customer>>(
            stream: cnt.getCustomerHasCmdConfirmed,
            initialData: [],
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text("Error"));
              } else {
                cnt.ligneCmdS.clear();
                for (var el in snapshot.data!) {
                  for (var element in el.cartData!) {
                    if (element.livred == true &&
                        element.canceled == false &&
                        element.closed == false &&
                        element.confiremdByAdmin == true &&
                        element.confirmed == true) {
                      cnt.ligneCmdS.addAll(element.cart!);
                    }
                  }
                }

                cnt.allUsersCommande.value = cnt.cartProducts(cnt.ligneCmdS);
                return SizedBox(
                  height: Get.height - 50,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: List.generate(
                              cnt.allUsersCommande.length,
                              (index) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: BrandColors.xboxGrey
                                                  .withOpacity(.3)),
                                          color: BrandColors.backgrounGray,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                        child: Text(
                                            '${cnt.allUsersCommande[index].product!.productName!}  (${cnt.allUsersCommande[index].qte} ${cnt.allUsersCommande[index].product!.unit}) '),
                                      ),
                                    ),
                                  )),
                        ),
                      ),
                      Expanded(
                        child: _CmdTable(
                            onShowDetail: (cus) {
                              showDialog(
                                  context: context,
                                  builder: (_) => Dialog(
                                        child: SizedBox(
                                          height: double.maxFinite,
                                          child: Column(
                                            children: [
                                              Text(
                                                  "اسم العميل: ${cus.fullName}"),
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Divider(
                                                  height: 50,
                                                ),
                                              ),
                                              Expanded(
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: List.generate(
                                                        cnt.customersHasCmd
                                                            .firstWhere((p0) =>
                                                                cus.uKey ==
                                                                p0.uKey)
                                                            .cartData!
                                                            .where((element) =>
                                                                element.livred == true &&
                                                                element.canceled ==
                                                                    false &&
                                                                element.confiremdByAdmin ==
                                                                    true &&
                                                                element.closed ==
                                                                    false &&
                                                                element.confirmed ==
                                                                    true)
                                                            .length,
                                                        (index) => Column(
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Column(
                                                                    children: [
                                                                      Container(
                                                                        color: BrandColors
                                                                            .kPrimaryColor,
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              Responsive(
                                                                            children: [
                                                                              const Div(
                                                                                  divison: Division(colS: 12, colM: 6, colL: 2),
                                                                                  child: Text(
                                                                                    'مرجع الطلبية:  ',
                                                                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                                                  )),
                                                                              Div(divison: const Division(colS: 12, colM: 6, colL: 6), child: Text(cus.cartData![index].key!)),
                                                                              Div(
                                                                                  divison: const Division(colS: 12, colM: 6, colL: 4),
                                                                                  child: Row(
                                                                                    children: [
                                                                                      const Text(
                                                                                        'المجموع:  ',
                                                                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                                                      ),
                                                                                      Text(DataConverter.currencyConvert(cnt.cartProducts(cus.cartData![index].cart!).sumTotal((element) => element.product!.isSale! ? element.qte! * element.product!.sPrice! : element.qte! * element.product!.nPrice!).toDouble())),
                                                                                    ],
                                                                                  )),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Column(
                                                                        children: List.generate(
                                                                            cnt.cartProducts(cus.cartData![index].cart!).length,
                                                                            (i) {
                                                                          var y = cnt.cartProducts(cus
                                                                              .cartData![index]
                                                                              .cart!);
                                                                          return Row(
                                                                            children: [
                                                                              Text(y[i].product!.productName!),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Text('x (${y[i].qte!.toString()} ${y[i].product!.unit!.toString()}) x',
                                                                                    style: const TextStyle(
                                                                                      fontSize: 14,
                                                                                    )),
                                                                              ),
                                                                              Directionality(
                                                                                textDirection: TextDirection.ltr,
                                                                                child: Text(y[i].product!.isSale! ? ' ${DataConverter.currencyConvert(y[i].product!.sPrice!.toDouble())}' : ' ${DataConverter.currencyConvert(y[i].product!.nPrice!.toDouble())}',
                                                                                    style: const TextStyle(
                                                                                      fontSize: 14,
                                                                                    )),
                                                                              ),
                                                                              Expanded(
                                                                                  child: Center(
                                                                                      child: Directionality(
                                                                                          textDirection: TextDirection.rtl,
                                                                                          child: Wrap(
                                                                                            children: [
                                                                                              const Text("="),
                                                                                              Text(y[i].product!.isSale! ? DataConverter.currencyConvert(y[i].product!.sPrice!.toDouble() * y[i].qte!) : DataConverter.currencyConvert(y[i].product!.nPrice!.toDouble() * y[i].qte!)),
                                                                                            ],
                                                                                          ))))
                                                                            ],
                                                                          );
                                                                        }),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                        child:
                                                                            Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child: ElevatedButton(
                                                                          onPressed: () async {
                                                                            cus.cartData![index].livred =
                                                                                true;
                                                                            cus.cartData![index].livredDate =
                                                                                cnt.dilevryDate.value;
                                                                          
                                                                            cnt.customerData.updateCmd(cus,
                                                                                cus.cartData![index]);

                                                                            setState(() {});

                                                                            Get.back();
                                                                          },
                                                                          child: const Text("تسليم الطلبية")),
                                                                    )),
                                                                    Expanded(
                                                                        child:
                                                                            Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child: ElevatedButton(
                                                                          onPressed: () {
                                                                            Get.back();
                                                                          },
                                                                          child: const Text("الغاء التسليم")),
                                                                    ))
                                                                  ],
                                                                ),
                                                              ],
                                                            )),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ));
                            },
                            onConfirm: (cus) {},
                            onCancel: (cus) {},
                            customers: cnt.customersHasCmd),
                      ),
                    ],
                  ),
                );
              }
            });
      } else {
        return const Loading();
      }
    });
  }
}

class _CmdTable extends StatelessWidget {
  final void Function(Customer cus) onShowDetail;
  final void Function(Customer cus) onConfirm;
  final void Function(Customer cus) onCancel;
  final List<Customer> customers;
  const _CmdTable(
      {required this.onShowDetail,
      required this.onConfirm,
      required this.onCancel,
      required this.customers});

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      //  onQueryRowHeight: (details) {
      //   return details.getIntrinsicRowHeight(details.rowIndex);
      // },
      source: _ItemsDataSource(
          customers: customers,
          onShowDetail: (Customer cus) => onShowDetail(cus),
          onConfirm: (Customer cus) => onConfirm(cus),
          onCancel: (Customer cus) => onCancel(cus)),
      columnWidthMode: ColumnWidthMode.fill,
      columns: <GridColumn>[
        GridColumn(
            columnName: 'Customer',
            label: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text(
                  'اسم العميل',
                  style: GoogleFonts.cairo(),
                ))),

        GridColumn(
            columnName: 'Tel',
            label: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text(
                  "الهاتف",
                  style: GoogleFonts.cairo(),
                ))),
        //    DataGridCell<String>(columnName: "Customer", value: e.fullName),
        // const DataGridCell<IconData>(
        // columnName: "ShowDetail.",
        //   value:FontAwesomeIcons.eye ),

        // const DataGridCell<IconData>(columnName: "Accept", value: FontAwesomeIcons.check),
        //const DataGridCell<IconData>(columnName: "Reject", value: FontAwesomeIcons.cancel),
        GridColumn(
            columnName: 'Adresse',
            label: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text(
                  "العنوان",
                  style: GoogleFonts.cairo(),
                ))),
        GridColumn(
            columnName: 'detail',
            label: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text(
                  'تفاصيل الطلبيات',
                  style: GoogleFonts.cairo(),
                ))),
      ],
    );
  }
}

class _ItemsDataSource extends DataGridSource {
  final void Function(Customer cus) onShowDetail;
  final void Function(Customer cus) onConfirm;
  final void Function(Customer cus) onCancel;
  _ItemsDataSource({
    required List<Customer> customers,
    required this.onShowDetail,
    required this.onConfirm,
    required this.onCancel,
  }) {
    _items = customers
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: "Customer", value: e.fullName),
              DataGridCell<String>(columnName: "Tel", value: e.telephone),
              DataGridCell<String>(columnName: "Adresse", value: e.adresse),
              DataGridCell<Customer>(columnName: "detail", value: e),
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
      if (e.columnName != "detail") {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(e.value.toString()),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: () => onShowDetail(e.value),
            icon: Center(
              child: Icon(
                FontAwesomeIcons.eye,
                color: BrandColors.xboxGreen,
                size: 25,
              ),
            ),
          ),
        );
      }
    }).toList());
  }
}


