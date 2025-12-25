import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/app/modules/home/views/widget/create_post_card.dart';
import 'package:social_app/app/modules/home/views/widget/post_card.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Social"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
          },
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            itemCount: 1 + 20,
            separatorBuilder: (context, index) => const SizedBox(height: 14),
            itemBuilder: (context, i) {
              if (i == 0) return const CreatePostCard();
              return PostCard(index: i - 1);
            },
          ),
        ),
      ),
    );
  }
}
