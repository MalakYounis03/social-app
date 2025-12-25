import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:social_app/app/widgets/custom_elevated_button.dart';
import 'package:social_app/app/widgets/custom_text_filed.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 16.0,
            ),
            child: Center(
              child: Column(
                children: [
                  Image.asset("assets/images/chats.png", width: 200),
                  SizedBox(height: 50),
                  CustomTextFiled(
                    hintText: "Email",
                    icon: Icons.email_outlined,
                  ),
                  SizedBox(height: 20),
                  CustomTextFiled(
                    hintText: "Password",
                    icon: Icons.lock_outline,
                  ),
                  SizedBox(height: 40),
                  CustomElevatedButton(text: "Login", onPressed: () {}),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Get.toNamed('/register');
                        },
                        child: Text("Register"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
