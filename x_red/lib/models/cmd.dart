import 'customers.dart';
import 'ligne_cmd.dart';

class Commandes {
  Customer? customer;
  String? key;
  DateTime? date;
  List<LigneCmd>? cart;
  bool? livred;
  bool? confirmed;
  bool? canceled;
  bool? closed;
  bool? confiremdByAdmin;
  DateTime? livredDate;
  String? cmdCode;

  Commandes(
      {this.key,
      this.date,
      this.cart,
      this.livred,
      this.confirmed,
      this.canceled,
      this.closed,
      this.customer,
      this.confiremdByAdmin,this.livredDate,this.cmdCode});
}
