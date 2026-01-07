import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/app/modules/home/controllers/home_controller.dart';
import 'package:social_app/app/modules/profile/views/widget/post_list.dart';
import 'package:social_app/app/modules/profile/views/widget/profile_header.dart';

class ProfileView extends GetView<HomeController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.fetchPosts,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            children: [ProfileHeader(), SizedBox(height: 14), PostsList()],
          ),
        ),
      ),
    );
  }
}
