import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/app/constants/app_colors.dart';
import 'package:social_app/app/constants/formate_post_time.dart';
import 'package:social_app/app/modules/chat_details/model/chat_details_model.dart';
import 'package:social_app/app/modules/chat_details/model/chat_model.dart';
import 'package:social_app/app/routes/app_pages.dart';

class ChatTile extends StatelessWidget {
  final Chat item;
  const ChatTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
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
                      Text(
                        item.lastMessage,

                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: AppColors.iconColor),
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  lastMessageAuthor() {
    if (item.lastMessageAuthor == item.otherUserId) {
      return item.name;
    } else {
      return "You";
    }
  }
}
