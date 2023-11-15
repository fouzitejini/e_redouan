import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../widgets/loading.dart';
import '../controllers/admin_controller.dart';
import 'admin_menu_view.dart';
import 'page_selector_view.dart';

class AdminView extends GetView<AdminController> {
  AdminView({Key? key}) : super(key: key);
  final cnt = Get.put(AdminController());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return cnt.loaded.value
            ? AdminMenu(
                deadSession: cnt.deadSession.value,
                cmds:cnt.actifCmds.length,
                ontap: (index) {
                  cnt.index.value = index;
                },
                menu: cnt.menu,
                child: PageSelectorView(
                  pageIndex: cnt.index.value,

                ),
              )
            : const Loading();
      },
    );
  }
}
