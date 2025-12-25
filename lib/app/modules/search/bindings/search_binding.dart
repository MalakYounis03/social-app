import 'package:get/get.dart';
import 'package:social_app/app/modules/search/controllers/search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchGetxController>(() => SearchGetxController());
  }
}
