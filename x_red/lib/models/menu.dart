import 'package:flutter/material.dart';

class MasterMenu {
  int? key;
  bool? isHover;
  String? title;
  IconData? icon;
  MenuType? menuType;
  String? route;
  MasterMenu({this.key, this.title, this.icon, this.menuType, this.isHover,this.route});
}

enum MenuType {
  single,
  multiple,
}