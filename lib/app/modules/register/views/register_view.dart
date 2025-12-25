import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:social_app/app/widgets/custom_elevated_button.dart';
import 'package:social_app/app/widgets/custom_text_filed.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});
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
                  Image.asset(
                    "assets/images/chats.png",
                    width: 200,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 50),
                  CustomTextFiled(hintText: "Name", icon: Icons.person_outline),
                  SizedBox(height: 20),

                  CustomTextFiled(
                    hintText: "Email",
                    icon: Icons.email_outlined,
                  ),
                  SizedBox(height: 20),
                  CustomTextFiled(
                    hintText: "Password",
                    icon: Icons.lock_outline,
                  ),
                  SizedBox(height: 20),
                  CustomTextFiled(
                    hintText: "Confirm Password",
                    icon: Icons.lock_outline,
                  ),
                  SizedBox(height: 40),
                  CustomElevatedButton(text: "Register", onPressed: () {}),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text("Already have an account?"),
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text("Login"),
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
