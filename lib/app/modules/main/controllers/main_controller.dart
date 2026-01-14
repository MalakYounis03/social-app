import 'package:get/get.dart';
import 'package:social_app/app/modules/chats/controllers/chats_controller.dart';

class MainController extends GetxController {
  final index = 0.obs;
  void change(int i) => index.value = i;
  final chatsController = Get.find<ChatsController>();
}
