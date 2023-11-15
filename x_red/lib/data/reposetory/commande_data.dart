import 'package:collection/collection.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:redouanstore/data/reposetory/firebase_database.dart';
import 'package:redouanstore/utilities/sum.dart';

import 'package:uuid/uuid.dart';
import '../../models/cmd.dart';
import '../../models/customers.dart';
import '../../models/ligne_cmd.dart';
import '../../models/product.dart';

class CustomerCommandes {
  var uuid = const Uuid();
  Future<void> create(Customer customer) async {
    try {
      await FirebaseDatabase.instance
          .ref("Users")
          .child(customer.uKey!)
          .set(Database.customerToMap(customer));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> update(Customer customer) async {
    try {
      await FirebaseDatabase.instance
          .ref("Users")
          .child(customer.uKey!)
          .update(Database.customerToMap(customer));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createCustomerCmd(Customer customer, Commandes cmd) async {
    await FirebaseDatabase.instance
        .ref("Users")
        .child(customer.uKey!)
        .child("cmd")
        .child(cmd.key!)
        .set(Database.cmdToMap(cmd));
  }

  Future<void> updateCmd(Customer customer, Commandes cmd) async {
    await FirebaseDatabase.instance
        .ref("Users")
        .child(customer.uKey!)
        .child("cmd")
        .child(cmd.key!)
        .update(Database.cmdToMap(cmd));
  }

  Future<void> updateCmdDilevry(Customer customer, Commandes cmd) async {
    await FirebaseDatabase.instance
        .ref("Users")
        .child(customer.uKey!)
        .child("cmd")
        .child(cmd.key!)
        .update(Database.cmdToMapLivreson(cmd));
  }

  Future<void> createLineCmd(Customer customer, Commandes cmd, LigneCmd cmdline,
      Product product) async {
    await FirebaseDatabase.instance
        .ref("Users")
        .child(customer.uKey!)
        .child("cmd")
        .child(cmd.key!)
        .child("cmdLine")
        .child(cmdline.key!)
        .set(Database.cmdLineToMap(cmdline, product));
  }

  Future<void> createProductLineCmd(Customer customer, Commandes cmd,
      LigneCmd cmdline, Product product) async {
    await FirebaseDatabase.instance
        .ref("Users")
        .child(customer.uKey!)
        .child("cmd")
        .child(cmd.key!)
        .child("cmdLine")
        .child(cmdline.key!)
        .child('Products')
        .set(Database.productToMapCmd(product));
  }

  Future<List<Commandes>> readcmd(Customer customer) async {
    List<Commandes> cmd = [];

    try {
      var ref = FirebaseDatabase.instance
          .ref("Users")
          .child(customer.uKey!)
          .child("cmd");

      await ref.once().then((event) {
        if (event.snapshot.value != null) {
          Map<dynamic, dynamic> dataMap = Map<String, dynamic>.from(
              event.snapshot.value as Map<Object?, Object?>);

          dataMap.forEach((key, value) async {
            var ccmd = Commandes(
              key: key.toString(),
              date: DateTime.tryParse(value['date'].toString()),
              livred: value['livred'] == null
                  ? false
                  : value['livred'] == 'true'
                      ? true
                      : false,
              confirmed: value['confirmed'] == null
                  ? false
                  : value['confirmed'] == 'true'
                      ? true
                      : false,
              canceled: value['canceled'] == null
                  ? false
                  : value['canceled'] == 'true'
                      ? true
                      : false,
              closed: value['closed'] == null
                  ? false
                  : value['closed'] == 'true'
                      ? true
                      : false,
              confiremdByAdmin: value['confiremdByAdmin'] == null
                  ? false
                  : value['confiremdByAdmin'] == 'true'
                      ? true
                      : false,
              cmdCode: value['code'] ?? '',
              livredDate: DateTime.tryParse(
                  value['livredDate'] ?? DateTime.now().toString()),
            );
            await readProductInCMD(customer, ccmd)
                .then((value) => ccmd.cart = value);

            cmd.add(ccmd);
          });
        }
      }).whenComplete(() => null);
    } catch (e) {
      print("cmd e: $e");
    }

    return cmd;
  }

  Future<List<Customer>> get readCustomers async {
    List<Customer> customers = [];
    try {
      await FirebaseDatabase.instance.ref("Users").once().then((data) {
        if (data.snapshot.value != null) {
          Map<dynamic, dynamic> dataMap = Map<String, dynamic>.from(
              data.snapshot.value as Map<Object?, Object?>);
          dataMap.forEach((key, value) async {
            var gOcusto = Customer(
              uKey: key,
              fullName: value['fullName'] ?? '',
              userName: value['usrName'] ?? '',
              userPwd: value['pwd'] ?? '',
              email: value['usrmail'] ?? '',
              adresse: value['usrAdresse'] ?? '',
              telephone: value['usrTel'] ?? '',
            );

            await readcmd(gOcusto).then((value) => gOcusto.cartData = value);

            customers.add(gOcusto);
          });
        }
      }).whenComplete(() => null);
    } catch (e) {}
    return customers;
  }

  Future<List<Commandes>> get readAllCmds async {
    List<Commandes> commands = [];
    List<Customer> customers_ = [];
    try {
      await FirebaseDatabase.instance.ref("Users").once().then((data) {
        if (data.snapshot.value != null) {
          Map<dynamic, dynamic> dataMap = Map<String, dynamic>.from(
              data.snapshot.value as Map<Object?, Object?>);
          dataMap.forEach((key, value) async {
            var gOcusto = Customer(
              uKey: key,
              fullName: value['fullName'] ?? '',
              userName: value['usrName'] ?? '',
              userPwd: value['pwd'] ?? '',
              email: value['usrmail'] ?? '',
              adresse: value['usrAdresse'] ?? '',
              telephone: value['usrTel'] ?? '',
            );
            customers_.add(gOcusto);
          });
        }
      }).whenComplete(() => customers_.forEach((element) async {
            FirebaseDatabase.instance
                .ref("Users")
                .child(element.uKey!)
                .child("cmd")
                .once()
                .then((event) {
              if (event.snapshot.value != null) {
                Map<dynamic, dynamic> dataMap = Map<String, dynamic>.from(
                    event.snapshot.value as Map<Object?, Object?>);

                dataMap.forEach((key, value) async {
                  var ccmd = Commandes(
                    key: key.toString(),
                    date: DateTime.tryParse(value['date'].toString()),
                    livred: value['livred'] == null
                        ? false
                        : value['livred'] == 'true'
                            ? true
                            : false,
                    confirmed: value['confirmed'] == null
                        ? false
                        : value['confirmed'] == 'true'
                            ? true
                            : false,
                    canceled: value['canceled'] == null
                        ? false
                        : value['canceled'] == 'true'
                            ? true
                            : false,
                    closed: value['closed'] == null
                        ? false
                        : value['closed'] == 'true'
                            ? true
                            : false,
                    confiremdByAdmin: value['confiremdByAdmin'] == null
                        ? false
                        : value['confiremdByAdmin'] == 'true'
                            ? true
                            : false,
                    cmdCode: value['code'] ?? '',
                    livredDate: DateTime.tryParse(
                        value['livredDate'] ?? DateTime.now().toString()),
                  );
                  await readProductInCMD(Customer(uKey: element.uKey), ccmd)
                      .then((value) => ccmd.cart = value);

                  commands.add(ccmd);
                });
              }
            }).whenComplete(() => null);
          }));
    } catch (e) {}
    return commands;
  }

  Future<List<Customer>> get readAllCustomersData async {
    List<Customer> customers = [];

    await FirebaseDatabase.instance.ref("Users").once().then((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> dataMap = Map<String, dynamic>.from(
            event.snapshot.value as Map<Object?, Object?>);
        dataMap.forEach((key, value) async {
          customers.add(Customer(
            uKey: key,
            fullName: value['fullName'] ?? '',
            userName: value['usrName'] ?? '',
            userPwd: value['pwd'] ?? '',
            email: value['usrmail'] ?? '',
            adresse: value['usrAdresse'] ?? '',
            telephone: value['usrTel'] ?? '',
          ));
        });
      }
    }).whenComplete(() => null);

    return customers;
  }

  Future<List<LigneCmd>> readProductInCMD(
      Customer customer, Commandes cmdProducts) async {
    List<LigneCmd> comd = [];

    try {
      await FirebaseDatabase.instance
          .ref("Users")
          .child(customer.uKey!)
          .child("cmd")
          .child(cmdProducts.key!)
          .child('cmdLine')
          .once()
          .then((event) {
        if (event.snapshot.value != null) {
          Map<dynamic, dynamic> dataMap = Map<String, dynamic>.from(
              event.snapshot.value as Map<Object?, Object?>);

          dataMap.forEach((key, value) async {
            comd.add(LigneCmd(
              key: key,
              qte: double.parse(value['qte'] ?? 1),
              product: Database.getProduct(value['Products']),
            ));
          });
        }
      });
    } catch (e) {
      print("L commande e: $e");
    }

    return comd;
  }

  List<LigneCmd> cartProducts(List<LigneCmd> items) {
    List<LigneCmd> productsL = [];

    Map<String, List<LigneCmd>> groupedItems =
        groupBy(items, (item) => item.product!.key!);
    groupedItems.forEach((key, value) {
      productsL.add(LigneCmd(
          product: items.firstWhere((element) => element.key == key).product,
          qte: value.sumTotal((el) => el.qte!).toDouble()));
    });

    return productsL;
  }

  removeProductsInCmd(
      Customer customer, Commandes cmdProducts, LigneCmd cmd) async {}

  Future<List<Customer>> get readNewAllCustomers async {
    List<Commandes> commands = [];
    List<Customer> customers_ = [];
    try {
      await FirebaseDatabase.instance.ref("Users").once().then((data) {
        if (data.snapshot.value != null) {
          Map<dynamic, dynamic> dataMap = Map<String, dynamic>.from(
              data.snapshot.value as Map<Object?, Object?>);
          dataMap.forEach((key, value) async {
            var gOcusto = Customer(
              uKey: key,
              fullName: value['fullName'] ?? '',
              userName: value['usrName'] ?? '',
              userPwd: value['pwd'] ?? '',
              email: value['usrmail'] ?? '',
              adresse: value['usrAdresse'] ?? '',
              telephone: value['usrTel'] ?? '',
            );
            customers_.add(gOcusto);
          });
        }
      }).whenComplete(() {
        customers_.forEach((element) async {
          FirebaseDatabase.instance
              .ref("Users")
              .child(element.uKey!)
              .child("cmd")
              .once()
              .then((event) {
            if (event.snapshot.value != null) {
              Map<dynamic, dynamic> dataMap = Map<String, dynamic>.from(
                  event.snapshot.value as Map<Object?, Object?>);

              dataMap.forEach((key, value) async {
                var ccmd = Commandes(
                  key: key.toString(),
                  date: DateTime.tryParse(value['date'].toString()),
                  livred: value['livred'] == null
                      ? false
                      : value['livred'] == 'true'
                          ? true
                          : false,
                  confirmed: value['confirmed'] == null
                      ? false
                      : value['confirmed'] == 'true'
                          ? true
                          : false,
                  canceled: value['canceled'] == null
                      ? false
                      : value['canceled'] == 'true'
                          ? true
                          : false,
                  closed: value['closed'] == null
                      ? false
                      : value['closed'] == 'true'
                          ? true
                          : false,
                  confiremdByAdmin: value['confiremdByAdmin'] == null
                      ? false
                      : value['confiremdByAdmin'] == 'true'
                          ? true
                          : false,
                  cmdCode: value['code'] ?? '',
                  livredDate: DateTime.tryParse(
                      value['livredDate'] ?? DateTime.now().toString()),
                );
                await readProductInCMD(Customer(uKey: element.uKey), ccmd)
                    .then((value) {
                      return ccmd.cart = value;
                    });

                commands.add(ccmd);
              });
            }
            element.cartData = commands;
            commands.clear();
          }).whenComplete(() => null);
        });
      });
    } catch (e) {}
    return customers_;
  }







  Future<List<Customer>> get readNewAllCustomersHasCmd async {
  
    List<Customer> customers_ = [];
    try {
        await FirebaseDatabase.instance.ref("Users").once().then((data) {
        if (data.snapshot.value != null) {
          Map<dynamic, dynamic> dataMap = Map<String, dynamic>.from(
              data.snapshot.value as Map<Object?, Object?>);
          dataMap.forEach((key, value) async {
            var gOcusto = Customer(
              uKey: key,
              fullName: value['fullName'] ?? '',
              userName: value['usrName'] ?? '',
              userPwd: value['pwd'] ?? '',
              email: value['usrmail'] ?? '',
              adresse: value['usrAdresse'] ?? '',
              telephone: value['usrTel'] ?? '',
            );

            await readcmd(gOcusto).then((value) => gOcusto.cartData = value.where((element) =>
                                                                    element.livred == false &&
                                                                    element.canceled ==
                                                                        false &&
                                                                    element.confiremdByAdmin ==
                                                                        false &&
                                                                    element.closed ==
                                                                        false &&
                                                                    element.confirmed ==
                                                                        true).toList());

            customers_.add(gOcusto);
          });
        }
      }).whenComplete(() => null);
    } catch (e) {}
           
    return customers_;
  }







Future<List<Customer>> get readNewAllCustomersHasCmdConfirmed async {
 
    List<Customer> customers_ = [];
    
    try {
        await FirebaseDatabase.instance.ref("Users").once().then((data) {
        if (data.snapshot.value != null) {
          Map<dynamic, dynamic> dataMap = Map<String, dynamic>.from(
              data.snapshot.value as Map<Object?, Object?>);
          dataMap.forEach((key, value) async {
            var gOcusto = Customer(
              uKey: key,
              fullName: value['fullName'] ?? '',
              userName: value['usrName'] ?? '',
              userPwd: value['pwd'] ?? '',
              email: value['usrmail'] ?? '',
              adresse: value['usrAdresse'] ?? '',
              telephone: value['usrTel'] ?? '',
            );

            await readcmd(gOcusto).then((value) => gOcusto.cartData = value.where((element) =>
                                                                    element.livred == false &&
                                                                    element.canceled ==
                                                                        false &&
                                                                    element.confiremdByAdmin ==
                                                                        true &&
                                                                    element.closed ==
                                                                        false &&
                                                                    element.confirmed ==
                                                                        true).toList());

            customers_.add(gOcusto);
          });
        }
      }).whenComplete(() => null);
    } catch (e) {}
           
    return customers_;
  }





Future<List<Customer>> get readNewAllCustomersHasCmdLivred async {
    List<Customer> customers_ = [];
    try {
        await FirebaseDatabase.instance.ref("Users").once().then((data) {
        if (data.snapshot.value != null) {
          Map<dynamic, dynamic> dataMap = Map<String, dynamic>.from(
              data.snapshot.value as Map<Object?, Object?>);
          dataMap.forEach((key, value) async {
            var gOcusto = Customer(
              uKey: key,
              fullName: value['fullName'] ?? '',
              userName: value['usrName'] ?? '',
              userPwd: value['pwd'] ?? '',
              email: value['usrmail'] ?? '',
              adresse: value['usrAdresse'] ?? '',
              telephone: value['usrTel'] ?? '',
            );

            await readcmd(gOcusto).then((value) => gOcusto.cartData = value.where((element) =>
                                                                    element.livred == true &&
                                                                    element.canceled ==
                                                                        false &&
                                                                    element.confiremdByAdmin ==
                                                                        true &&
                                                                    element.closed ==
                                                                        false &&
                                                                    element.confirmed ==
                                                                        true).toList());

            customers_.add(gOcusto);
          });
        }
      }).whenComplete(() => null);
    } catch (e) {}
           
    return customers_;
  }







  Future<List<Customer>> get readNewAllCustomersHasCmdCanceled async {
    List<Customer> customers_ = [];
    try {
        await FirebaseDatabase.instance.ref("Users").once().then((data) {
        if (data.snapshot.value != null) {
          Map<dynamic, dynamic> dataMap = Map<String, dynamic>.from(
              data.snapshot.value as Map<Object?, Object?>);
          dataMap.forEach((key, value) async {
            var gOcusto = Customer(
              uKey: key,
              fullName: value['fullName'] ?? '',
              userName: value['usrName'] ?? '',
              userPwd: value['pwd'] ?? '',
              email: value['usrmail'] ?? '',
              adresse: value['usrAdresse'] ?? '',
              telephone: value['usrTel'] ?? '',
            );

            await readcmd(gOcusto).then((value) => gOcusto.cartData = value.where((element) =>
                                                                  
                                                                    element.canceled ==
                                                                        true).toList());

            customers_.add(gOcusto);
          });
        }
      }).whenComplete(() => null);
    } catch (e) {}
           
    return customers_;
  }
}
/** .where((element) =>
                                                                    element.livred == false &&
                                                                    element.canceled ==
                                                                        false &&
                                                                    element.confiremdByAdmin ==
                                                                        false &&
                                                                    element.closed ==
                                                                        false &&
                                                                    element.confirmed ==
                                                                        true) */