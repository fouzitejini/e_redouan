import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:redouanstore/data/colors.dart';
import 'package:redouanstore/utilities/data_converter.dart';
import 'package:responsive_ui/responsive_ui.dart';

import '../../../../widgets/loading.dart';
import '../controllers/admin_controller.dart';

class CompanySettingsView extends StatefulWidget {
  CompanySettingsView({Key? key}) : super(key: key);

  @override
  State<CompanySettingsView> createState() => _CompanySettingsViewState();
}

class _CompanySettingsViewState extends State<CompanySettingsView> {
  final cnt = Get.put(AdminController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (cnt.onLoad.value) {
        return const Loading();
      } else if (cnt.error.value) {
        return Center(
          child: Text("Error".tr),
        );
      } else if (cnt.loaded.value) {
        return SizedBox(
          height: Get.height - 60,
          width: Get.width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Container()),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                          onPressed: () async {
                            await cnt
                                .uploadFileToBase64()
                                .whenComplete(() => showDialog(
                                    context: context,
                                    builder: (_) => Dialog(
                                          child: SizedBox(
                                            height: 300,
                                            width: 250,
                                            child: Column(children: [
                                              Expanded(
                                                  child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5),
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    child: Image.memory(
                                                      cnt.productUploadedImage
                                                          .value,
                                                      height: 150,
                                                      fit: BoxFit.fitWidth,
                                                    )),
                                              )),
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: ElevatedButton(
                                                        onPressed: () async {
                                                          Get.back();
                                                          showDialog(
                                                            barrierDismissible: false,
                                                              context: context,
                                                              builder: (_) =>
                                                                  const Dialog(
                                                                    child: SizedBox(
                                                                        height:
                                                                            200,
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Column(
                                                                              children: [
                                                                                Expanded(child: Center(child: LinearProgressIndicator())),
                                                                                Expanded(child: Center(child:Text("جاري تحميل الصورة")),)
                                                                              ],
                                                                            )),
                                                                  ));
                                                          await cnt
                                                              .uploadImageSliderToStorage();
                                                          cnt.companyData
                                                              .createSlidersImages(
                                                                  cnt.uuid.value
                                                                      .v1(),
                                                                  cnt.categoryUploadedImagePath
                                                                      .value);
                                                          cnt.waitToUpload
                                                              .value = true;
                                                          await cnt
                                                              .getCompanySettings();
                                                          Get.back();
                                                        },
                                                        child:
                                                            const Text("حفظ")),
                                                  )),
                                                  Expanded(
                                                      child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: ElevatedButton(
                                                        onPressed: () {
                                                          Get.back();
                                                        },
                                                        child: const Text(
                                                            "الغاء")),
                                                  ))
                                                ],
                                              )
                                            ]),
                                          ),
                                        )));
                          },
                          child: Text("اضافة صورة".tr)),
                    )
                  ],
                ),
                Responsive(
                  children: List.generate(
                      cnt.company.value.sliderImages!.length,
                      (i) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Div(
                                divison:
                                    const Division(colS: 6, colM: 3, colL: 2),
                                child: InkWell(
                                  onTap: () {},
                                  onHover: (e) {
                                    cnt.company.value.sliderImages![i].isHover =
                                        e;
                                    setState(() {});
                                  },
                                  child: cnt.company.value.sliderImages![i]
                                          .isHover!
                                      ? SizedBox(
                                          height: 150,
                                          child: Stack(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  height: 150,
                                                  child: Image.network(
                                                      cnt
                                                          .company
                                                          .value
                                                          .sliderImages![i]
                                                          .img!,
                                                      fit: BoxFit.fitHeight),
                                                ),
                                              ),
                                              Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (_) => Dialog(
                                                                        child:
                                                                            SizedBox(
                                                                          height:
                                                                              200,
                                                                          width:
                                                                              300,
                                                                          child:
                                                                              Column(children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Text("هل تريد حذف الصورة".tr),
                                                                            ),
                                                                            Expanded(
                                                                              child: Container(),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(10),
                                                                              child: Row(
                                                                                children: [
                                                                                  Expanded(
                                                                                      child: Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: ElevatedButton(
                                                                                        onPressed: () async {
                                                                                          await cnt.companyData.removeSlidersImage(cnt.company.value.sliderImages![i].key!);
                                                                                          await cnt.getCompanySettings();
                                                                                          Get.back();
                                                                                        },
                                                                                        child: const Text("نعم")),
                                                                                  )),
                                                                                  Expanded(
                                                                                      child: Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: ElevatedButton(
                                                                                        onPressed: () {
                                                                                          Get.back();
                                                                                        },
                                                                                        child: const Text("لا")),
                                                                                  ))
                                                                                ],
                                                                              ),
                                                                            )
                                                                          ]),
                                                                        ),
                                                                      ));
                                                        },
                                                        icon: Icon(Icons.delete,
                                                            size: 40,
                                                            color: BrandColors
                                                                .alpamareBlue)),
                                                    IconButton(
                                                      onPressed: () {},
                                                      icon: Icon(
                                                        FontAwesomeIcons.eye,
                                                        size: 40,
                                                        color: BrandColors
                                                            .alpamareBlue,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      : SizedBox(
                                          height: 150,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.network(
                                                cnt.company.value
                                                    .sliderImages![i].img!,
                                                fit: BoxFit.fitHeight),
                                          )),
                                )),
                          )),
                ),
                const Divider(),
                Row(
                  children: [
                    Expanded(child: Container()),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                          onPressed: () {
                            cnt.companyNameController.value.text =
                                cnt.company.value.companyName!;

                            cnt.companyTelephoneController.value.text =
                                cnt.company.value.telephone!;

                            cnt.companyFixController.value.text =
                                cnt.company.value.fix!;

                            cnt.companyFaxController.value.text =
                                cnt.company.value.fax!;

                            cnt.companyFacebookController.value.text =
                                cnt.company.value.faceBook!;

                            cnt.companyWahtsappController.value.text =
                                cnt.company.value.whatsapp!;

                            cnt.companyEmailController.value.text =
                                cnt.company.value.email!;

                            cnt.companyAboutController.value.text =
                                cnt.company.value.about!;
                            cnt.showCompanySettings();
                          },
                          child: Text("تعديل".tr)),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text.rich(TextSpan(
                      text: "اسم امؤسسة:  ",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700),
                      children: [
                        TextSpan(
                            text: cnt.company.value.companyName!,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w100))
                      ])),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text.rich(TextSpan(
                      text: " رقم الهاتف :  ",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700),
                      children: [
                        TextSpan(
                            text: cnt.company.value.fix!,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w100))
                      ])),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text.rich(TextSpan(
                      text: "الفاكس:  ",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700),
                      children: [
                        TextSpan(
                            text: cnt.company.value.fax!,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w100))
                      ])),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text.rich(TextSpan(
                      text: "الجوال:  ",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700),
                      children: [
                        TextSpan(
                            text: cnt.company.value.telephone!,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w100))
                      ])),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text.rich(TextSpan(
                      text: "رقم الواتساب:  ",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700),
                      children: [
                        TextSpan(
                            text: cnt.company.value.whatsapp!.toString(),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w100))
                      ])),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text.rich(TextSpan(
                      text: "الاميل:  ",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700),
                      children: [
                        TextSpan(
                            text: cnt.company.value.email!.toString(),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w100))
                      ])),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text.rich(TextSpan(
                      text: "صفحة الفيسبوك:  ",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700),
                      children: [
                        TextSpan(
                            text: cnt.company.value.faceBook!.toString(),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w100))
                      ])),
                ),
                const Divider(),
                Row(
                  children: [
                    Expanded(child: Container()),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                          onPressed: () {
                            cnt.minCartCostController.value.text =
                                cnt.company.value.cartLimitMnt!.toString();
                            cnt.minCartCostDescriptionController.value.text =
                                cnt.company.value.cartLimitDescription!
                                    .toString();
                            cnt.showCartCompnaySettings();
                          },
                          child: Text("تعديل".tr)),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    const Text.rich(TextSpan(
                      text: "المبلغ الادنى للطلبية:  ",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    )),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text.rich(
                        TextSpan(
                            text: DataConverter.currencyConvert(
                                cnt.company.value.cartLimitMnt!),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w100)),
                      ),
                    ),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text.rich(TextSpan(
                      text: "اعلان حول المبلغ الادنى للطلبية: ",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700),
                      children: [
                        TextSpan(
                            text: cnt.company.value.cartLimitDescription!
                                .toString(),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w100))
                      ])),
                ),
                const Divider(),
                Row(
                  children: [
                    Expanded(child: Container()),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                          onPressed: () {
                            cnt.companyAboutController.value.text =
                                cnt.company.value.about!.toString();

                            cnt.showCompanyAboutSettiong();
                          },
                          child: Text("تعديل".tr)),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    const Text(
                      "حول:  ",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    Expanded(
                      child: Container(
                        color: BrandColors.backgrounGray,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            cnt.company.value.about!,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w100),
                            maxLines: null,
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(child: Container()),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                            onPressed: () {
                              cnt.companyAboutController.value.text =
                                  cnt.company.value.about!.toString();

                              cnt.showCompanyUserSettings();
                            },
                            child: Text("تعديل".tr)),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text.rich(TextSpan(
                      text: "اسم المستخدم:  ",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700),
                      children: [
                        TextSpan(
                            text: cnt.company.value.user!.toString(),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w100))
                      ])),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text.rich(TextSpan(
                      text: "رمز الدخول:  ",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700),
                      children: [
                        TextSpan(
                            text: cnt.company.value.pwd!.toString(),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w100))
                      ])),
                )
              ],
            ),
          ),
        );
      }

      return const Center(
        child: Text(
          'View is working',
          style: TextStyle(fontSize: 20),
        ),
      );
    });
  }
}
