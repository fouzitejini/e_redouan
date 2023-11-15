import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:redouanstore/app/modules/home/controllers/home_controller.dart';
import 'package:redouanstore/app/modules/home/views/head_foot.dart';
import 'package:redouanstore/models/category.dart';
import 'package:redouanstore/widgets/loading.dart';

import '../../../../models/cmd.dart';
import '../../../../models/customers.dart';
import '../../../../models/ligne_cmd.dart';
import '../../../../models/product.dart';
import '../../../../widgets/product_card.dart';
import '../../../routes/app_pages.dart';
import '../controllers/categories_controller.dart';

class CategoriesView extends GetView<CategoriesController> {
  CategoriesView({Key? key}) : super(key: key);

  final cnt = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return cnt.loaded.value
            ? MasterHome(
                child: FutureBuilder<Category>(
                    future: cnt.category,
                    initialData: Category(),
                    builder: (context, category) {
                      if (category.connectionState == ConnectionState.done) {
                        cnt.categorie.value = category.data!;
                        return ProductCard(
                          backSpace: true,
                          product: cnt.categorie.value,
                          carteQte: (p) async {
                            await cnt.createO();
                            await cnt.saveCmd(
                                Customer(uKey: cnt.cnt.userID.value),
                                Commandes(
                                    key: cnt.cnt.cmdIDOP.value,
                                    livred: false,
                                    confirmed: false,
                                    closed: false,
                                    canceled: false),
                                LigneCmd(
                                    key: cnt.uuid.value.v4(),
                                    qte: 1,
                                    product: p),
                                p);
                            cnt.onInit();

                            cnt.newCommand.value = true;
                          },
                          buttonEnabled: cnt.newCommand.value,
                          onTap: (back, p) {
                            cnt.backVisible.value = back;
                            Get.toNamed(Routes.PRODUCT_DETAIL, parameters: {
                              "p": p.key!,
                              'back': cnt.backVisible.value.toString()
                            });
                          },
                        );
                      } else {
                        return Loading();
                      }
                    }),
              )
            : const Loading();
      },
    );
  }
}
