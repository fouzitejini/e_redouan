import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:redouanstore/app/modules/admin/views/company_settings.dart';

import 'admin_acount_view.dart';
import 'admin_home_view.dart';
import 'categories_management_view.dart';
import 'cmd_confirmed_view.dart';
import 'customer_cmds_view.dart';
import 'product_management_view.dart';

class PageSelectorView extends GetView {
  const PageSelectorView({Key? key, required this.pageIndex}) : super(key: key);
  
  final int pageIndex;
  @override
  Widget build(BuildContext context) {
    if (pageIndex == 1) {
      return AdminHomeView();
    } else if (pageIndex == 9) {
      return const  CustomerCMDSConfirmedView();
    } else if (pageIndex == 3) {
      return CategoriesManagementView();
    } else if (pageIndex == 4) {
      return ProductManagementView();
    } else if (pageIndex == 8) {
      return  const CustomerCMDSView();
    } else if (pageIndex == 15) {
      return CompanySettingsView();
    }
    return Container();
  }
}
