import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/app/constants/app_colors.dart';

class HomeController extends GetxController {
  final textController = TextEditingController();
  RxBool canPost = false.obs;
  @override
  void onInit() {
    textController.addListener(onTextChanged);
    super.onInit();
  }

  void onTextChanged() {
    canPost.value = textController.text.trim().isNotEmpty;
  }

  @override
  void dispose() {
    textController.removeListener(onTextChanged);
    textController.dispose();
    super.dispose();
  }

  void publish() {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    // TODO: اربطيها بالكونترولر لاحقاً
    // Get.find<HomeController>().addPost(text);

    textController.clear();
    FocusScope.of(Get.context!).unfocus();

    Get.snackbar(
      "Posted",
      "Your post has been published",
      backgroundColor: AppColors.fillColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
    );
  }
}
