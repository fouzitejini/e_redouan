import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:randomstring_dart/randomstring_dart.dart';
import 'package:redouanstore/app/modules/home/controllers/headfootcontroller_controller.dart';
import 'package:responsive_ui/responsive_ui.dart';

import '../../../../models/cmd.dart';
import '../../../../models/customers.dart';
import '../../../../models/ligne_cmd.dart';
import '../../../../widgets/loading.dart';
import '../../../../widgets/product_card.dart';
import '../../../../widgets/slider.dart';

import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key, required this.onTap}) : super(key: key);
  final cnt = Get.put(HomeController());
  final void Function(double ex) onTap;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (cnt.loaded.value) {
        return Center(
          child: SingleChildScrollView(
            child: Responsive(
              children: [
                Div(
                  divison: const Division(colL: 12, colM: 12, colS: 12),
                  child: cnt.company.value.sliderImages!.isEmpty
                      ? Container()
                      : HomeSlider(
                          children: List.generate(
                            cnt.company.value.sliderImages!.length,
                            (index) => Container(
                                color: Colors.amber,
                                child: Image.network(
                                  cnt.company.value.sliderImages![index].img!,
                                  width: double.maxFinite,
                                  height: double.maxFinite,
                                  fit: BoxFit.fill,
                                )),
                          ),
                        ),
                ),
                Responsive(
                    children: List.generate(
                        cnt.categories.length,
                        (index) => Div(
                                child: Column(
                              children: [
                                ProductCard(
                                  onTap: (back, pro) {
                                    cnt.backVisible.value = back;
                                    Get.toNamed(Routes.PRODUCT_DETAIL,
                                        parameters: {"p": pro.key!});
                                  },
                                  backSpace: cnt.backVisible.value,
                                  product: cnt.categories[index],
                                  carteQte: (p) async {
                                    cnt.newCommand.value = false;
                               
                                    await cnt.createO();

                                    await cnt.saveCmd(
                                        Customer(uKey: cnt.cnt.userID.value),
                                        Commandes(
                                            key: cnt.cnt.cmdIDOP.value,
                                           
                                            livred: false,
                                            confirmed: false,
                                            closed: false,
                                            canceled: false,
                                            confiremdByAdmin: false),
                                        LigneCmd(
                                            key: cnt.uuid.value.v4(),
                                            qte: 1,
                                            product: p),
                                        p);
                                    cnt.init();
                                    onTap(cnt.badgeQte.value);
                                    cnt.newCommand.value = true;
                                  },
                                  buttonEnabled: cnt.newCommand.value,
                                ),
                              ],
                            ))))
              ],
            ),
          ),
        );
      } else {
        return const Loading();
      }
    });
  }
}
