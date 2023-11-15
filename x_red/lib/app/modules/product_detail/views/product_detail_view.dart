import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:responsive_ui/responsive_ui.dart';

import '../../../../data/colors.dart';

import '../../../../models/cmd.dart';
import '../../../../models/customers.dart';
import '../../../../models/ligne_cmd.dart';
import '../../../../utilities/data_converter.dart';
import '../../../../widgets/loading.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/views/head_foot.dart';
import '../controllers/product_detail_controller.dart';

class ProductDetail extends StatelessWidget {
  const ProductDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ProductDetailView extends StatefulWidget {
  ProductDetailView({Key? key}) : super(key: key);
  final cnt = Get.put(HomeController());
  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  // final cnt = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return MasterHome(
      child: GetX<ProductDetailController>(builder: (cnt) {
        if (cnt.isOnload.value) {
          return const Center(
            child: Loading(),
          );
        } else {
          if (cnt.isError.value) {
            return Center(
              child: Text("Error".tr),
            );
          } else if (cnt.isLoaded.value) {
            cnt.productDetail();
            return Responsive(children: [
              Visibility(
                visible:cnt.backSpace.value,
                child: Row(
                  children: [
                    Expanded(child: Container()),
                    IconButton(
                        onPressed: () {
                          Get.back();
                          },
                        icon: Icon(Icons.arrow_forward,color: BrandColors.googleRed,size: 30,))
                  ],
                ),
              ),
              Div(
                  divison: const Division(colS: 12, colM: 6, colL: 6, colXL: 6),
                  child: SizedBox(
                    height: Get.height - 200,
                    child: Center(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(0),
                            child: Image.network(
                              cnt.item.value.img!,
                              width: double.infinity,
                              fit: BoxFit.fitHeight,
                            ))),
                  )),
              Div(
                  divison: const Division(colS: 12, colM: 6, colL: 6, colXL: 6),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(cnt.item.value.productName!,
                                style: const TextStyle(fontSize: 22)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: Text(
                                  DataConverter.currencyConvert(
                                      cnt.item.value.isSale!
                                          ? cnt.item.value.sPrice!
                                          : cnt.item.value.nPrice!),
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: BrandColors.almouasat,
                                      fontWeight: FontWeight.w700)),
                            ),
                            !cnt.item.value.isSale!
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 1,
                                              color: BrandColors.xboxGreen,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: BrandColors.xboxGreen),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3),
                                          child: Text("تخفيض",
                                              style: TextStyle(
                                                  color: BrandColors
                                                      .kPrimaryColor)),
                                        )),
                                  )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton.outlined(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.favorite,
                                  color: BrandColors.alpamareBlue,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton.outlined(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.share,
                                  color: BrandColors.oldGoldColor,
                                )),
                          ),
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: BrandColors.lightSliverColor),
                          width: double.infinity,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("السعر",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: BrandColors.almouasat,
                                                fontWeight: FontWeight.w700)),
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: SizedBox(
                                          width: 150,
                                          height: 80,
                                          child: Directionality(
                                            textDirection: TextDirection.ltr,
                                            child: Text(
                                                DataConverter.currencyConvert(
                                                    cnt
                                                            .item.value.isSale!
                                                        ? cnt.item.value
                                                                .sPrice! *
                                                            cnt.qte.value
                                                        : cnt.item.value
                                                                .nPrice! *
                                                            cnt.qte.value),
                                                style:
                                                    TextStyle(
                                                        fontSize: 18,
                                                        color: BrandColors
                                                            .almouasat,
                                                        fontWeight:
                                                            FontWeight.w700)),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            "الكمية ب: ${cnt.item.value.unit!}",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: BrandColors.almouasat,
                                                fontWeight: FontWeight.w700)),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 250,
                                            height: 80,
                                            child: Directionality(
                                              textDirection: TextDirection.ltr,
                                              child: CupertinoSpinBox(
                                                decimals: 1,
                                                step: 0.5,
                                                min: 0.5,
                                                max: 100,
                                                value: cnt.qte.value,
                                                onChanged: (value) {
                                                  setState(() {
                                                    cnt.qte.value = value;
                                                    cnt.sum.value =
                                                        cnt.item.value.isSale!
                                                            ? cnt.item.value
                                                                    .sPrice! *
                                                                value
                                                            : cnt.item.value
                                                                    .nPrice! *
                                                                value;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton.icon(
                                      onPressed: () async {
                                        await cnt.createO();
                                        await cnt.saveCmd(
                                            Customer(uKey: cnt.userID.value),
                                            Commandes(key: cnt.cmdIDOP.value),
                                            LigneCmd(
                                                key: cnt.uuid.value.v4(),
                                                qte: cnt.qte.value,
                                                product: cnt.item.value),
                                            cnt.item.value);
                                        cnt.qte.value = 1;
                                        await cnt.init();
                                      },
                                      icon: const Icon(
                                          FontAwesomeIcons.cartShopping),
                                      label: const Text("اضافة الى السلة"),
                                    ),
                                  )),
                                  Expanded(
                                      child: Visibility(
                                    visible: false,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton.icon(
                                        onPressed: () {},
                                        icon: const Icon(
                                            Icons.monetization_on_outlined),
                                        label: const Text("اشتري الان"),
                                      ),
                                    ),
                                  ))
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )),
            ]);
          } else {
            return const Text("Unkow,");
          }
        }
      }),
    );
  }
}
