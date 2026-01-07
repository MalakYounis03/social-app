import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/chat_details_controller.dart';

class ChatDetailsView extends GetView<ChatDetailsController> {
  const ChatDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ChatDetails'), centerTitle: true),
      body: const Center(
        child: Text(
          'ChatDetailsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
