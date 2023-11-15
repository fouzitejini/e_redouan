import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../models/admin_menu.dart';

class AdminMenuController extends GetxController {
  var index = 1.obs;
  final menu = <AdminMasterMenu>[].obs;
  List<AdminMasterMenu> get adminMenu => [
        AdminMasterMenu(
          index: 1,
          key: '1',
          menuTitle: 'ادارة الموقع',
          icon: FontAwesomeIcons.home,
          subMenu: homeSubMenu,
        ),
        AdminMasterMenu(
            index: 2,
            key: '2',
            menuTitle: 'المخزن',
            icon: FontAwesomeIcons.store,
            subMenu: storeSubMenu),
        AdminMasterMenu(
            index: 3,
            key: '3',
            menuTitle: 'العملاء',
            icon: FontAwesomeIcons.person,
            subMenu: cmdSubMenu),
        AdminMasterMenu(
            index: 4,
            key: '5',
            menuTitle: 'اعدادات',
            icon: Icons.settings,
            subMenu:settingsSubMenu),
      ];

  final onLoad = false.obs;
  final loaded = false.obs;
  final error = false.obs;
  @override
  void onInit() {
    try {
      menu.value = adminMenu;

      onLoad.value = true;
      loaded.value = false;
      error.value = false;
    } catch (e) {
      onLoad.value = false;
      loaded.value = false;
      error.value = true;

      return;
    } finally {
      onLoad.value = false;
      loaded.value = true;
      error.value = false;
    }
    super.onInit();
  }

  List<AdminSubMenu> get storeSubMenu => [
        AdminSubMenu(
          index: 3,
          key: '1',
          menuTitle: 'الاصناف',
          icon: Icons.category,
          onTap: () {
            index.value = 3;
          },
        ),
        AdminSubMenu(
            index: 4,
            key: '2',
            menuTitle: 'المنتجات',
            icon: FontAwesomeIcons.productHunt,
            onTap: () {  index.value = 4;}),
        /*   AdminSubMenu(
         index: 5,
          key: '3',
          menuTitle: 'القفة',
          icon: FontAwesomeIcons.bagShopping,
          hasView: true,
          route: Routes.CATEGORY_MANAGEMENT),
      AdminSubMenu(
         index:6,
          key: '4',
          menuTitle: 'العروض',
          icon: FontAwesomeIcons.percent,
          hasView: true,
          route: Routes.CATEGORY_MANAGEMENT),*/
      ];
  List<AdminSubMenu> get cmdSubMenu => [
      
        AdminSubMenu(
            index: 8,
            key: '1',
            menuTitle: 'طلبيات العملاء',
            icon: FontAwesomeIcons.cartShopping,
            onTap: () {  index.value = 8;}),
        AdminSubMenu(
            index: 9,
            key: '2',
            menuTitle: 'طلبيات طور الانتظار',
            icon: FontAwesomeIcons.cartFlatbed,
            onTap: () {  index.value = 9;}),
    /**  AdminSubMenu(
            index: 10,
            key: '3',
            menuTitle: 'طلبيات ملغية',
            icon: Icons.close,
            onTap: () {  index.value = 10;}),*/ 
              AdminSubMenu(
            index: 7,
            key: '0',
            menuTitle: 'حسابات العملاء',
            icon: Icons.account_circle,
            onTap: () {  index.value = 7;}),
      ];
  List<AdminSubMenu> get homeSubMenu => [
        /* AdminSubMenu(
         index:0,
          key: '1',
          menuTitle: 'رئيسية الموقع',
          icon: Icons.home_sharp,
          hasView: false,
          route: Routes.HOME),*/

        AdminSubMenu(
            index: 1,
            key: '2',
            menuTitle: 'رئيسية ادارة الموقع',
            icon: FontAwesomeIcons.home,
            onTap: () {  index.value = 1;}),
        //    route: Routes.PRODUCT_MANAGEMENT),
        /*   AdminSubMenu(
         index: 2,
        key: '3',
        menuTitle: 'حساب المشرفين',
        icon: FontAwesomeIcons.shield,
        hasView: true,
        //route: Routes.PRODUCT_MANAGEMENT
      ),*/
      ];
      List<AdminSubMenu> settingsSubMenu= 
      [
        AdminSubMenu(
            index: 15,
            key: '2',
            menuTitle: 'الاعدادات الرئيسية',
            icon: FontAwesomeIcons.toolbox,
            onTap: () { }),
      ];
}
