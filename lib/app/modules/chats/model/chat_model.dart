import 'package:intl/intl.dart';

class Chat {
  String name;
  String imageUrl;
  String otherUserId;
  String lastMessage;
  String lastMessageAuthor;
  int lastMessageTime;

  String get formattedTime {
    return DateFormat(
      'hh:mm a',
    ).format(DateTime.fromMillisecondsSinceEpoch(lastMessageTime));
  }

  String get formattedDate {
    return DateFormat(
      'MMM d',
    ).format(DateTime.fromMillisecondsSinceEpoch(lastMessageTime));
  }

  Chat({
    required this.name,
    required this.imageUrl,
    required this.otherUserId,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.lastMessageAuthor,
  });

  factory Chat.fromJson(String key, Map<dynamic, dynamic> json) {
    return Chat(
      name: json['name'],
      imageUrl: json['imageUrl'],
      otherUserId: key,
      lastMessage: json['lastMessage'],
      lastMessageTime: json['lastMessageTime'],
      lastMessageAuthor: json['lastMessageAuthor'],
    );
  }
}
