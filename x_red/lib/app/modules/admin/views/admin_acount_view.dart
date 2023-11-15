import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

import 'package:get/get.dart';
import 'package:redouanstore/data/colors.dart';
import 'package:redouanstore/widgets/loading.dart';

import '../controllers/admin_controller.dart';

class AdminAcountView extends GetView {
  AdminAcountView({Key? key}) : super(key: key);
  final cnt = Get.put(AdminController());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (cnt.loaded.value) {
        return Scaffold(
          body: SizedBox(
              height: Get.height,
              width: Get.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                            width: 1, color: BrandColors.alpamareBlue)),
                    child: Form(
                      key: cnt.form,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.key,
                            color: BrandColors.alpamareBlue,
                            size: 70,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 20, bottom: 20, right: 20),
                            child: Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: TextFormField(
                                onChanged: (e) {},
                                controller: cnt.adminUserController.value,
                                validator:
                                    ValidationBuilder().minLength(3).build(),
                                decoration: InputDecoration(
                                    border: const OutlineInputBorder(
                                        borderSide: BorderSide(width: 1)),
                                    labelText: "اسم المستخدم".tr,
                                    isCollapsed: true,
                                    contentPadding: const EdgeInsets.only(
                                        left: 15,
                                        right: 15,
                                        top: 10,
                                        bottom: 10)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 20, bottom: 20, right: 20),
                            child: Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: TextFormField(
                                obscureText: true,
                                onChanged: (e) {},
                                controller: cnt.adminPwdController.value,
                                validator:
                                    ValidationBuilder().minLength(3).build(),
                                decoration: InputDecoration(
                                    border: const OutlineInputBorder(
                                        borderSide: BorderSide(width: 1)),
                                    labelText: "رمز الدخول".tr,
                                    isCollapsed: true,
                                    contentPadding: const EdgeInsets.only(
                                        left: 15,
                                        right: 15,
                                        top: 10,
                                        bottom: 10)),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (cnt.form.currentState!.validate()) {
                                        await  cnt.checkLogin();
                                        }
                                      },
                                      child: const Text(
                                        "تاكيد",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )),
        );
      } else {
        return const Loading();
      }
    });
  }
}
