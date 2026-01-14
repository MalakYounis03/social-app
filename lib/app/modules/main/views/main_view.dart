import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:social_app/app/constants/app_colors.dart';
import 'package:social_app/app/modules/chats/views/chats_view.dart';
import 'package:social_app/app/modules/home/views/home_view.dart';
import 'package:social_app/app/modules/main/controllers/main_controller.dart';
import 'package:social_app/app/modules/profile/views/profile_view.dart';
import 'package:social_app/app/modules/search/views/search_view.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});
  @override
  Widget build(BuildContext context) {
    final pages = [HomeView(), SearchView(), ChatsView(), ProfileView()];
    return Scaffold(
      body: Obx(
        () => IndexedStack(index: controller.index.value, children: pages),
      ),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 70,
          backgroundColor: AppColors.background,
          selectedIndex: controller.index.value,
          onDestinationSelected: controller.change,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              label: "Home",
            ),
            NavigationDestination(icon: Icon(Icons.search), label: "Search"),

            Obx(() {
              final total = controller.chatsController.unread.totalUnread.value;

              return Stack(
                clipBehavior: Clip.none,

                children: [
                  NavigationDestination(
                    icon: Icon(Icons.chat_bubble_outline),
                    label: "Chats",
                  ),
                  if (total > 0)
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          total.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
