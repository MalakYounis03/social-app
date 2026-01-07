import 'package:get/get.dart';
import 'package:social_app/app/modules/home/controllers/home_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
