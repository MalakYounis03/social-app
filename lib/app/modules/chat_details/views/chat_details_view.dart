import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:social_app/app/constants/app_colors.dart';
import 'package:social_app/app/modules/chat_details/model/chat_details_model.dart';
import '../controllers/chat_details_controller.dart';

class ChatDetailsView extends GetView<ChatDetailsController> {
  const ChatDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final chat = controller.chat;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(chat.otherUserImageUrl),
            ),
            const SizedBox(width: 10),
            Text(
              chat.otherUserName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Messages
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.messages.isEmpty) {
                  return Center(
                    child: Text(
                      "No messages yet. Say hi!",
                      style: TextStyle(color: AppColors.hintText),
                    ),
                  );
                }
                final items = controller.messages;

                return ListView.builder(
                  reverse: true,
                  controller: controller.scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  itemCount: items.length + (controller.hasMore.value ? 1 : 0),
                  itemBuilder: (_, i) {
                    if (i == items.length) {
                      return Obx(() {
                        if (!controller.hasMore.value)
                          return const SizedBox.shrink();

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Center(
                            child: controller.isFeatchingMore.value
                                ? const CircularProgressIndicator()
                                : const Text("اسحب لفوق لتحميل رسائل أقدم"),
                          ),
                        );
                      });
                    }

                    return _MessageBubble(item: items[items.length - 1 - i]);
                  },
                );
              }),
            ),

            // Input bar
            Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              decoration: BoxDecoration(
                color: AppColors.background,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.fillColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller.textController,
                              minLines: 1,
                              maxLines: 5,
                              decoration: InputDecoration(
                                hintText: "Type a message...",
                                hintStyle: TextStyle(color: AppColors.hintText),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            splashRadius: 18,
                            onPressed: () {},
                            icon: Icon(
                              Icons.emoji_emotions_outlined,
                              color: AppColors.iconColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: controller.sendMessages,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.send,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends GetView<ChatDetailsController> {
  final ChatMessage item;
  const _MessageBubble({required this.item});

  @override
  Widget build(BuildContext context) {
    final isMe = item.senderId == controller.user.id;
    final bubbleColor = isMe
        ? AppColors.primary.withOpacity(0.22)
        : AppColors.fillColor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Flexible(
            child: GestureDetector(
              onLongPressStart: isMe
                  ? (details) async {
                      final tapPosition = details.globalPosition;
                      final value = await showMenu<String>(
                        context: context,
                        position: RelativeRect.fromLTRB(
                          tapPosition.dx,
                          tapPosition.dy,
                          tapPosition.dx,
                          tapPosition.dy,
                        ),
                        items: [
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: Text('Delete Message'),
                          ),
                        ],
                      );
                      if (value == 'delete') {
                        controller.deleteMessageForEveryone(item);
                      }
                    }
                  : null,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.78,
                ),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isMe ? 18 : 6),
                      bottomRight: Radius.circular(isMe ? 6 : 18),
                    ),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.message,
                        style: const TextStyle(
                          color: Colors.white,
                          height: 1.25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        DateFormat('h:mm a').format(
                          DateTime.fromMillisecondsSinceEpoch(item.messageTime),
                        ),
                        style: TextStyle(
                          color: AppColors.hintText,
                          fontSize: 11,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
