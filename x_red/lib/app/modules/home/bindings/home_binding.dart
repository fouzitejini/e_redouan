import 'package:get/get.dart';



import '../controllers/headfootcontroller_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HeaderController>(
      () => HeaderController(),
    );
      Get.lazyPut<HomeController>(
      () => HomeController(),
     );
  }
}
