import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/app/constants/end_points.dart';
import 'package:social_app/app/modules/login/model/login_model.dart';
import 'package:social_app/app/routes/app_pages.dart';
import 'package:social_app/app/services/api_services.dart';
import 'package:social_app/app/services/auth_services.dart';

class LoginController extends GetxController with StateMixin<void> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  var isLoading = false.obs;
  final authService = Get.find<AuthServices>();
  final apiService = Get.find<ApiServices>();

  Future<void> login(BuildContext context) async {
    if (!loginFormKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      final response = await apiService.post(
        endPoint: EndPoints.login,
        body: {
          'email': emailController.text,
          'password': passwordController.text,
        },
        fromJson: LoginModel.fromJson,
      );

      await authService.saveLoginData(response.token, response.user);
      isLoading.value = false;
      Get.offAllNamed(Routes.MAIN);
    } catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
