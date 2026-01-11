import 'package:social_app/app/data/user_model.dart';
import 'package:social_app/app/modules/chat_details/model/chat_model.dart';

class ChatDetails {
  String otherUserId;
  String otherUserName;
  String otherUserImageUrl;

  ChatDetails({
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserImageUrl,
  });

  factory ChatDetails.newChat(UserModel user) {
    return ChatDetails(
      otherUserId: user.id,
      otherUserName: user.name,
      otherUserImageUrl: user.imageUrl,
    );
  }

  factory ChatDetails.existChat(Chat chat) {
    return ChatDetails(
      otherUserId: chat.otherUserId,
      otherUserName: chat.name,
      otherUserImageUrl: chat.imageUrl,
    );
  }
}

class ChatMessage {
  final String id;
  final String message;
  final int messageTime;
  final String senderId;

  ChatMessage({
    required this.id,
    required this.message,
    required this.messageTime,
    required this.senderId,
  });

  factory ChatMessage.fromMap(String id, Map data) {
    return ChatMessage(
      id: id,
      message: data["message"],
      messageTime: data["messageTime"],
      senderId: data["senderId"],
    );
  }
}
