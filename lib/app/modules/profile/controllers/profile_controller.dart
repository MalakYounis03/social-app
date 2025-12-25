import 'package:get/get.dart';

class ProfileController extends GetxController {
  final name = "Mohammed".obs;
  final username = "@mohammed".obs;
  final bio = "Building a clean social app UI with Flutter + GetX.".obs;

  final postsCount = 12.obs;

  final myPosts = <String>[
    "اول منشور الي 🔥",
    "تجربة واجهة Home و Profile على الثيم الغامق",
    "GetX مرتب وسهل 😄",
    "UI فكرة بسيطة بس بتفرق كثير",
  ].obs;

  void openSettings() {
    // Get.toNamed(Routes.SETTINGS);
  }

  void editProfile() {
    // Get.toNamed(Routes.EDIT_PROFILE);
  }
}
