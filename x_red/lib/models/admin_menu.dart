import 'package:flutter/material.dart';

class AdminMasterMenu {
  int? index;
  String? key;
  String? menuTitle;
  IconData? icon;
  List<AdminSubMenu>? subMenu;
  AdminMasterMenu(
      {this.key, this.menuTitle, this.icon, this.subMenu, this.index});
}

class AdminSubMenu {
  int? index;
  String? key;
  String? menuTitle;
  IconData? icon;
  void Function() ? onTap;
  AdminSubMenu({this.key, this.menuTitle, this.icon, this.index,required this.onTap});
}
