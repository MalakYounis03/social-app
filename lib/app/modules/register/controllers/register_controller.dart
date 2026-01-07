import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/app/constants/end_points.dart';
import 'package:social_app/app/modules/register/model/register_model.dart';
import 'package:social_app/app/routes/app_pages.dart';
import 'package:social_app/app/services/api_services.dart';
import 'package:social_app/app/services/auth_services.dart';

class RegisterController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  var isLoading = false.obs;
  final authService = Get.find<AuthServices>();
  final apiService = Get.find<ApiServices>();

  Future<void> register(BuildContext context) async {
    if (!registerFormKey.currentState!.validate()) return;

    try {
      final response = await apiService.post(
        endPoint: EndPoints.register,
        body: {
          'username': nameController.text,
          'email': emailController.text,
          'password': passwordController.text,
        },
        fromJson: RegisterModel.fromJson,
      );
      await authService.saveLoginData(response.token, response.user);
      Get.offAllNamed(Routes.MAIN);
      print(response.token);
      print(response.user);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
