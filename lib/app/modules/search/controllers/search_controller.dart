import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchGetxController extends GetxController {
  final textController = TextEditingController();

  final query = ''.obs;
  final tabIndex = 0.obs;

  final people = List.generate(20, (i) => "User $i");
  final posts = List.generate(
    30,
    (i) => "This is a post from user $i about Flutter and GetX in dark theme.",
  );

  @override
  void onInit() {
    textController.addListener(onChanged);
    super.onInit();
  }

  void onChanged() {
    query.value = textController.text.trim();
  }

  void clear() {
    textController.clear();
    query.value = '';
  }

  void setTab(int i) => tabIndex.value = i;

  List<String> get filteredPeople {
    if (query.value.isEmpty) return [];
    final q = query.value.toLowerCase();
    return people.where((u) => u.toLowerCase().contains(q)).toList();
  }

  List<String> get filteredPosts {
    if (query.value.isEmpty) return [];
    final q = query.value.toLowerCase();
    return posts.where((p) => p.toLowerCase().contains(q)).toList();
  }

  @override
  void onClose() {
    textController.removeListener(onChanged);
    textController.dispose();
    super.onClose();
  }
}
