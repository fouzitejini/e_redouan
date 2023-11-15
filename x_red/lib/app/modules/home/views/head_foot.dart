import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:redouanstore/app/modules/home/controllers/home_controller.dart';
import 'package:redouanstore/data/colors.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import '../../../../widgets/loading.dart';
import '../controllers/headfootcontroller_controller.dart';

class MasterHome extends GetView {
  MasterHome({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;
  
  final cnt = Get.put(HeaderController());
  @override
  Widget build(context) {
    return Scaffold(
        floatingActionButton: SizedBox(
          height: 50,
          width: 50,
          child: RippleAnimation(
            color: Colors.deepOrange,
            delay: const Duration(milliseconds: 300),
            repeat: true,
            minRadius: 30,
            ripplesCount: 6,
            duration: const Duration(milliseconds: 6 * 300),
            child: IconButton(
              onPressed: ()async {
                  var link = WhatsAppUnilink(
                                      phoneNumber: Get.find<HomeController>().company.value.whatsapp,
                                      text: "خضر وفواكه الرضوان",
                                    );
                                    await launchUrl(link.asUri());
              },
              icon: Icon(
                FontAwesomeIcons.whatsapp,
                size: 30,
                color: BrandColors.backgrounGray,
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: BrandColors.whatsappColor),
            ),
          ),
        ),
        body: Obx(() {
          if (cnt.onLoad.value) {
            return const Loading();
          } else if (cnt.loaded.value) {
            return Column(
              children: [
                cnt.header,
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        child,
                        cnt.footer,
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: Text("Error".tr),
            );
          }
        }));
  }
}
