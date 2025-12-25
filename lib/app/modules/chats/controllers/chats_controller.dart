import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatsController extends GetxController {
  final searchController = TextEditingController();
  final query = ''.obs;

  // Dummy data (بدّلها لاحقًا ببيانات Firebase/API)
  final chats = <ChatItem>[
    ChatItem(
      name: "Mohammed",
      lastMessage: "وينك؟",
      time: "2:30 PM",
      photo: "assets/images/chats.png",
    ),
    ChatItem(
      name: "Ahmad",
      lastMessage: "تمام🔥",
      time: "1:10 PM",
      photo: "assets/images/chats.png",
    ),
    ChatItem(
      name: "Sara",
      lastMessage: "ابعثلي الملف",
      time: "Yesterday",
      photo: "assets/images/chats.png",
    ),
    ChatItem(
      name: "Omar",
      lastMessage: "😂😂",
      time: "Mon",
      photo: "assets/images/chats.png",
    ),
  ].obs;

  @override
  void onInit() {
    searchController.addListener(_onChanged);
    super.onInit();
  }

  void _onChanged() => query.value = searchController.text.trim();

  void clearSearch() {
    searchController.clear();
    query.value = '';
  }

  List<ChatItem> get filteredChats {
    if (query.value.isEmpty) return chats;
    final q = query.value.toLowerCase();
    return chats
        .where(
          (c) =>
              c.name.toLowerCase().contains(q) ||
              c.lastMessage.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  void onClose() {
    searchController.removeListener(_onChanged);
    searchController.dispose();
    super.onClose();
  }
}

class ChatItem {
  final String name;
  final String lastMessage;
  final String time;
  final String photo;
  ChatItem({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.photo,
  });
}
