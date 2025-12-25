import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/app/modules/profile/views/widget/post_list.dart';
import 'package:social_app/app/modules/profile/views/widget/profile_header.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          children: const [ProfileHeader(), SizedBox(height: 14), PostsList()],
        ),
      ),
    );
  }
}
