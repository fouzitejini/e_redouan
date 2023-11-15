


import 'cmd.dart';

class Customer {
  String? uKey;
  String? userName;
  String? userPwd;
  bool? isUser;
  String? fullName;
  String? adresse;
  String? telephone;
  String? email;
  bool? connected;
  String? cart;
  List<Commandes>? cartData;
  Customer(
      {this.uKey,
      this.userName,
      this.userPwd,
      this.isUser,
      this.fullName,
      this.adresse,
      this.email,
      this.telephone,
      this.cart,this.connected,this.cartData});
}
