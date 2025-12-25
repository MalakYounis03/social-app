import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/app/constants/app_colors.dart';
import 'package:social_app/app/modules/chats/views/widget/chat_tile.dart';
import '../controllers/chats_controller.dart';

class ChatsView extends GetView<ChatsController> {
  const ChatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        actions: [
          IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.fillColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: controller.searchController,
                        decoration: InputDecoration(
                          hintText: "Search chats",
                          hintStyle: TextStyle(color: AppColors.hintText),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Obx(() {
                      final show = controller.query.value.isNotEmpty;
                      return show
                          ? IconButton(
                              splashRadius: 18,
                              icon: Icon(Icons.close),
                              onPressed: controller.clearSearch,
                            )
                          : const SizedBox.shrink();
                    }),
                  ],
                ),
              ),
            ),

            // List
            Expanded(
              child: Obx(() {
                final items = controller.filteredChats;

                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 42,
                          color: AppColors.hintText,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "No chats found",
                          style: TextStyle(color: AppColors.hintText),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  itemCount: items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (_, i) => ChatTile(item: items[i]),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
