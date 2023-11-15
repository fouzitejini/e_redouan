import 'package:get/get.dart';

import 'package:redouanstore/app/modules/admin/controllers/company_settings_controller.dart';

import '../controllers/admi_menu_controller_controller.dart';
import '../controllers/admin_controller.dart';
import '../controllers/category_management_controller_controller.dart';
import '../controllers/customer_cmds_controller.dart';
import '../controllers/productmanagement_controller.dart';

class AdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompanySettingsController>(
      () => CompanySettingsController(),
    );
    Get.lazyPut<CustomerCmdsController>(
      () => CustomerCmdsController(),
    );
    Get.lazyPut<ProductmanagementController>(
      () => ProductmanagementController(),
    );
    Get.lazyPut<CategoryManagementControllerController>(
      () => CategoryManagementControllerController(),
    );
    Get.lazyPut<AdminMenuController>(
      () => AdminMenuController(),
    );
    Get.lazyPut<AdminController>(
      () => AdminController(),
    );
  }
}
