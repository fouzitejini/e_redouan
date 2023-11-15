import 'dart:html';

import 'package:get/get.dart';

import '../../../../data/reposetory/categorie_data.dart';
import '../../../../models/category.dart';

class CategoriesController extends GetxController {
  final categoryReposetory = CategoriesData();
  final onLoad = true.obs;
  final loaded = false.obs;
  final categorie = Category().obs;
  final newCommand = true.obs;
  final categories = <Category>[].obs;
  @override
  void onInit() async {
    try {
      onLoad.value = true;
      loaded.value = false;
      await categoryReposetory.readCategories.then((value) {
        categories.value = value
            .where((element) => element.products!
                .where((element) => element.visiblity)
                .isNotEmpty)
            .toList();
      }).timeout(const Duration(seconds: 20), onTimeout: () {});
      await category.then((value) => categorie.value = value);
    } catch (e) {
    } finally {
      onLoad.value = false;
      loaded.value = true;
    }
    super.onInit();
  }

  Future<Category> get category async {
    var uri = Uri.dataFromString(window.location.href);
    if (uri.queryParameters.isNotEmpty) {
      var par = uri.queryParameters['c'].toString();
      Get.appUpdate();
      return categories.firstWhere((element) => element.key == par);
    }
    return Category();
  }
}
