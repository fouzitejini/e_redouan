import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../widgets/loading.dart';
import '../../home/views/head_foot.dart';
import '../controllers/about_controller.dart';

class AboutView extends GetView<AboutController> {
  AboutView({Key? key}) : super(key: key);
  final cnt = Get.put(AboutController());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
        if (cnt.loaded.value){
        return MasterHome(
        child:cnt.about);
      }else{
            return const Loading();
      }
    });
  }
}
