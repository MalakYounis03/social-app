import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/app/constants/app_colors.dart';
import 'package:social_app/app/constants/formate_post_time.dart';
import 'package:social_app/app/modules/chat_details/model/chat_details_model.dart';
import 'package:social_app/app/modules/chats/controllers/chats_controller.dart';
import 'package:social_app/app/modules/chats/model/chat_model.dart';
import 'package:social_app/app/routes/app_pages.dart';

class ChatTile extends GetView<ChatsController> {
  final Chat item;
  const ChatTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final unread = controller.unread.unreadByChat[item.otherUserId] ?? 0;

      return InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          controller.markChatAsRead(item.otherUserId);

          Get.toNamed(
            Routes.CHAT_DETAILS,
            arguments: {'chat': ChatDetails.existChat(item)},
          );
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.fillColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(item.imageUrl),
                  ),
                ],
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),

                    Row(
                      children: [
                        Text(lastMessageAuthor() + ": "),
                        Expanded(
                          child: Text(
                            item.lastMessage,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: AppColors.iconColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatPostTime(
                      DateTime.fromMillisecondsSinceEpoch(item.lastMessageTime),
                    ),
                    style: TextStyle(color: AppColors.hintText, fontSize: 12),
                  ),
                  const SizedBox(height: 8),

                  // ✅ bubble unread
                  if (unread > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        unread.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  lastMessageAuthor() {
    if (item.lastMessageAuthor == item.otherUserId) {
      return item.name;
    } else {
      return "You";
    }
  }
}
