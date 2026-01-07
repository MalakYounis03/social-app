import 'package:get/get.dart';
import 'package:social_app/app/modules/chats/controllers/chats_controller.dart';
import 'package:social_app/app/modules/home/controllers/home_controller.dart';
import 'package:social_app/app/modules/search/controllers/search_controller.dart';

import '../controllers/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<SearchGetxController>(() => SearchGetxController());
    Get.lazyPut<ChatsController>(() => ChatsController());
  }
}
