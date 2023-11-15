import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:redouanstore/app/modules/home/controllers/home_controller.dart';

import '../../../../data/reposetory/company_settings_data.dart';
import '../../../../models/company.dart';
import '../../home/controllers/headfootcontroller_controller.dart';

class AboutController extends GetxController {
  var companyData = CompanySettings();
  var cnt0 = Get.put(HomeController());
   var cnt= Get.put(HeaderController());
  final onLoad = true.obs;
  final loaded = false.obs;
  final val = false.obs;
  final error = false.obs;
  final company = Company().obs;

  @override
  void onInit() async {
    try {
      onLoad.value = true;
      loaded.value = false;
      error.value = false;
         await companyData.getCompanyData.then((value) => company.value = value);
     
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

  Widget get about => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text.rich(TextSpan(
            text: "من نحن\n".tr,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            children: [
              TextSpan(
                text: company.value.about!,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w200),
              )
            ])),
  );
}
