import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:social_app/app/modules/chats/controllers/chats_controller.dart';

class ChatDetailsController extends GetxController {
  late final ChatItem chat;

  final textController = TextEditingController();
  final scrollController = ScrollController();

  final messages = <ChatMessage>[].obs;

  @override
  void onInit() {
    super.onInit();

    chat = Get.arguments as ChatItem;

    // Dummy messages (بدّلهم لاحقًا بـ Firebase)
    messages.addAll([
      ChatMessage(text: "هلا كيفك؟", isMe: false, time: "2:18 PM"),
      ChatMessage(text: "تمام الحمدلله، انت؟", isMe: true, time: "2:19 PM"),
      ChatMessage(text: "ابعثلي الملف لو سمحت", isMe: false, time: "2:20 PM"),
      ChatMessage(text: "تم ✅", isMe: true, time: "2:20 PM"),
      ChatMessage(text: "هلا كيفك؟", isMe: false, time: "2:18 PM"),
      ChatMessage(text: "تمام الحمدلله، انت؟", isMe: true, time: "2:19 PM"),
      ChatMessage(text: "ابعثلي الملف لو سمحت", isMe: false, time: "2:20 PM"),
      ChatMessage(text: "تم ✅", isMe: true, time: "2:20 PM"),
      ChatMessage(text: "هلا كيفك؟", isMe: false, time: "2:18 PM"),
      ChatMessage(text: "تمام الحمدلله، انت؟", isMe: true, time: "2:19 PM"),
      ChatMessage(text: "ابعثلي الملف لو سمحت", isMe: false, time: "2:20 PM"),
      ChatMessage(text: "تم ✅", isMe: true, time: "2:20 PM"),
      ChatMessage(text: "هلا كيفك؟", isMe: false, time: "2:18 PM"),
      ChatMessage(text: "تمام الحمدلله، انت؟", isMe: true, time: "2:19 PM"),
      ChatMessage(text: "ابعثلي الملف لو سمحت", isMe: false, time: "2:20 PM"),
      ChatMessage(text: "تم ✅", isMe: true, time: "2:20 PM"),
    ]);
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void send() {
    final txt = textController.text.trim();
    if (txt.isEmpty) return;

    messages.add(ChatMessage(text: txt, isMe: true, time: _nowLabel()));
    textController.clear();

    // Scroll لآخر الرسائل
    Future.delayed(const Duration(milliseconds: 50), () {
      if (!scrollController.hasClients) return;
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  String _nowLabel() {
    final now = TimeOfDay.now();
    final h = now.hourOfPeriod == 0 ? 12 : now.hourOfPeriod;
    final m = now.minute.toString().padLeft(2, '0');
    final p = now.period == DayPeriod.am ? "AM" : "PM";
    return "$h:$m $p";
  }
}

class ChatMessage {
  final String text;
  final bool isMe;
  final String time;

  ChatMessage({required this.text, required this.isMe, required this.time});
}
