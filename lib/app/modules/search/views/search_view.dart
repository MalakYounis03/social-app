import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/app/constants/app_colors.dart';
import 'package:social_app/app/modules/search/controllers/search_controller.dart';
import 'package:social_app/app/modules/search/views/widget/empty_state.dart';
import 'package:social_app/app/modules/search/views/widget/person_tile.dart';
import 'package:social_app/app/modules/search/views/widget/post_mini_card.dart';
import 'package:social_app/app/modules/search/views/widget/search_hint.dart';
import 'package:social_app/app/modules/search/views/widget/tap_button.dart';

class SearchView extends GetView<SearchGetxController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search")),
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
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
                        controller: controller.textController,
                        decoration: InputDecoration(
                          hintText: "Search people or posts",
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
                              onPressed: controller.clear,
                            )
                          : const SizedBox.shrink();
                    }),
                  ],
                ),
              ),
            ),

            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Obx(
                () => Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.fillColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      TabButton(
                        text: "People",
                        selected: controller.tabIndex.value == 0,
                        onTap: () => controller.setTab(0),
                      ),
                      TabButton(
                        text: "Posts",
                        selected: controller.tabIndex.value == 1,
                        onTap: () => controller.setTab(1),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: Obx(() {
                final q = controller.query.value;
                final tab = controller.tabIndex.value;

                if (q.isEmpty) {
                  return const SearchHint();
                }

                if (tab == 0) {
                  final items = controller.filteredPeople;
                  if (items.isEmpty) {
                    return const EmptyState(text: "No people found");
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    itemCount: items.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (_, i) => PersonTile(name: items[i]),
                  );
                } else {
                  final items = controller.filteredPosts;
                  if (items.isEmpty) {
                    return const EmptyState(text: "No posts found");
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    itemCount: items.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (_, i) => PostMiniCard(text: items[i]),
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
