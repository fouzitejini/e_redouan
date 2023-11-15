import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:redouanstore/data/reposetory/firebase_database.dart';
import '../../models/customers.dart';
class CustomerData {
  Future<void> create(Customer customer) async {
    try {
      await FirebaseDatabase.instance
          .ref()
          .child("Users")
          .child(customer.uKey!)
          .set(Database.customerToMap(customer));
      Get.back();
    } catch (e) {
      rethrow;
    }
  }
  Future<void> update(Customer customer) async {
    try {
      await FirebaseDatabase.instance
          .ref()

          .child("Users")
          .child(customer.uKey!)
          .update(Database.customerToMap(customer));

      Get.back();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Customer>> get readCustomers async {
    List<Customer> customers = [];
    var ref = FirebaseDatabase.instance.ref().child("Users");

   await ref.once().then((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> dataMap = Map<String, dynamic>.from(
            event.snapshot.value as Map<Object?, Object?>);
        dataMap.forEach((key, value) async {
          customers.add(Customer(
            uKey: value['key'],
            fullName: value['fullName'],
            userName: value['usrName'],
            userPwd: value['pwd'],
            email: value['keusrmaily'],
            adresse: value['usrAdresse'],
            telephone: value['usrTel'],
          ));
        });
      }
    });
    return customers;
  }


}
