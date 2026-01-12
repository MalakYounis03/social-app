import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:social_app/app/modules/chat_details/model/chat_details_model.dart';
import 'package:social_app/app/services/auth_services.dart';

class ChatDetailsController extends GetxController {
  final db = FirebaseDatabase.instance.ref();
  final authService = Get.find<AuthServices>();
  final textController = TextEditingController();
  StreamSubscription<DatabaseEvent>? _messagesSubscription;
  StreamSubscription<DatabaseEvent>? _metaSubscription;
  StreamSubscription<DatabaseEvent>? _childRemovedSub;
  late final user = authService.user.value!;
  late final String chatId;

  final ChatDetails chat = Get.arguments['chat'];
  final messages = <ChatMessage>[].obs;
  final isLoading = false.obs;

  final scrollController = ScrollController();
  //Pagination
  static const int pageSize = 15;
  int? _oldestMessageTime;
  final isFeatchingMore = false.obs;
  final hasMore = true.obs;

  final isEmojiVisible = false.obs; // لو GetX
  final focusNode = FocusNode();

  RxInt otherLastSeen = 0.obs;
  DatabaseReference get metaRef => db.child('chat-details/$chatId/meta');

  DatabaseReference get lastSeenByRef => metaRef.child('lastSeenBy');

  @override
  void onInit() async {
    super.onInit();
    chatId = buildChatId(user.id, chat.otherUserId);
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        isEmojiVisible.value = false;
      }
    });
    //Panigation
    scrollController.addListener(() {
      if (!hasMore.value || isFeatchingMore.value) return;
      if (!scrollController.hasClients) return;
      final pos = scrollController.position;

      if (pos.pixels >= pos.maxScrollExtent - 80) {
        fetchMoreMessages();
      }
    });

    _listenToMeta();

    await _fetchMessages();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      markSeen();
    });

    _listenToNewMessages();
  }

  Future<void> _fetchMessages() async {
    isLoading.value = true;

    try {
      final event = await db
          .child("chat-details/$chatId/messages")
          .orderByChild("messageTime")
          .limitToLast(pageSize)
          .once(DatabaseEventType.value);

      final childs =
          event.snapshot.children
              .map(
                (e) => ChatMessage.fromMap(
                  e.key!,
                  e.value as Map<dynamic, dynamic>,
                ),
              )
              .toList()
            ..sort((a, b) => a.messageTime.compareTo(b.messageTime));

      messages.assignAll(childs);

      if (childs.isNotEmpty) _oldestMessageTime = childs.first.messageTime;
      hasMore.value = childs.length == pageSize;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMoreMessages() async {
    if (!hasMore.value) return;

    if (isFeatchingMore.value) return;

    final oldestTime = _oldestMessageTime;
    if (oldestTime == null) {
      return;
    }

    isFeatchingMore.value = true;

    try {
      final event = await db
          .child("chat-details/$chatId/messages")
          .orderByChild("messageTime")
          .endAt(oldestTime - 1)
          .limitToLast(pageSize)
          .once(DatabaseEventType.value);

      if (!event.snapshot.exists) {
        hasMore.value = false;
        return;
      }

      final older =
          event.snapshot.children
              .map(
                (e) => ChatMessage.fromMap(
                  e.key!,
                  e.value as Map<dynamic, dynamic>,
                ),
              )
              .toList()
            ..sort((a, b) => a.messageTime.compareTo(b.messageTime));

      if (older.isEmpty) {
        hasMore.value = false;
        return;
      }
      final existingIds = messages.map((m) => m.id).toSet();
      final toInsert = older.where((m) => !existingIds.contains(m.id)).toList();

      if (toInsert.isNotEmpty) {
        messages.insertAll(0, toInsert);
        _oldestMessageTime = messages.first.messageTime;
      }
      hasMore.value = older.length == pageSize;
    } finally {
      isFeatchingMore.value = false;
    }
  }

  void _listenToNewMessages() {
    final baseQuery = db
        .child("chat-details/$chatId/messages")
        .orderByChild("messageTime");

    final lastTime = messages.isEmpty ? 0 : messages.last.messageTime;

    _messagesSubscription = baseQuery.startAt(lastTime + 1).onChildAdded.listen(
      (event) {
        final data = event.snapshot.value;
        if (data == null) return;

        final msgData = Map<dynamic, dynamic>.from(data as Map);
        final newMessage = ChatMessage.fromMap(
          event.snapshot.key ?? '',
          msgData,
        );

        final exists = messages.any((m) => m.id == newMessage.id);

        if (exists) return;
        messages.add(newMessage);
        if (newMessage.senderId == chat.otherUserId) {
          markSeen();
        }
      },
    );
    _childRemovedSub = baseQuery.onChildRemoved.listen((event) {
      final id = event.snapshot.key;
      if (id == null) return;
      messages.removeWhere((m) => m.id == id);
    });
  }

  Future<void> sendMessages() async {
    final text = textController.text.trim();
    if (text.isEmpty) return;
    final newMessageRef = db.child("chat-details/$chatId/messages").push();

    final newMessageTime = DateTime.now().millisecondsSinceEpoch;
    isEmojiVisible.value = false;

    textController.clear();
    final tempId = newMessageRef.key ?? '';
    messages.add(
      ChatMessage(
        id: tempId,
        message: text,
        messageTime: newMessageTime,
        senderId: user.id,
      ),
    );

    await newMessageRef.set({
      "message": text,
      "messageTime": newMessageTime,
      "senderId": user.id,
    });

    await db.child("list-of-chats/${user.id}/${chat.otherUserId}").update({
      "name": chat.otherUserName,
      "imageUrl": chat.otherUserImageUrl,
      "lastMessage": text,
      "lastMessageTime": newMessageTime,
      "lastMessageAuthor": user.id,
    });

    await db.child("list-of-chats/${chat.otherUserId}/${user.id}").update({
      "name": user.name,
      "imageUrl": user.imageUrl,
      "lastMessage": text,
      "lastMessageTime": newMessageTime,
      "lastMessageAuthor": user.id,
    });
  }

  String buildChatId(String id1, String id2) {
    final ids = [id1, id2];
    ids.sort();
    final reversed = ids.reversed.toList();
    return reversed.join('____');
  }

  Future<void> deleteMessageForEveryone(ChatMessage msg) async {
    final messageRef = db.child("chat-details/$chatId/messages/${msg.id}");
    messages.removeWhere((m) => m.id == msg.id);

    await messageRef.remove();
    await _updateLastMessageAfterDelete(msg);
  }

  Future<void> _updateLastMessageAfterDelete(ChatMessage deletedMsg) async {
    final myId = user.id;
    final otherId = chat.otherUserId;

    final myChatRef = db.child("list-of-chats/$myId/$otherId");
    final otherChatRef = db.child("list-of-chats/$otherId/$myId");

    final messagesRef = db.child("chat-details/$chatId/messages");

    final lastMsgEvent = await messagesRef
        .orderByChild('messageTime')
        .limitToLast(1)
        .once(DatabaseEventType.value);

    if (!lastMsgEvent.snapshot.exists) {
      await myChatRef.remove();
      await otherChatRef.remove();
      return;
    }
    final lastSnap = lastMsgEvent.snapshot;

    final DataSnapshot msgSnap = lastSnap.children.first;

    final lastMsgData = msgSnap.value as Map<dynamic, dynamic>;

    final updateData = {
      'lastMessage': lastMsgData['message'] ?? '',
      'lastMessageAuthor': lastMsgData['senderId'] ?? '',
      'lastMessageTime': lastMsgData['messageTime'] ?? 0,
    };

    await myChatRef.update(updateData);
    await otherChatRef.update(updateData);
  }

  void _listenToMeta() {
    _metaSubscription = metaRef.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data == null) {
        otherLastSeen.value = 0;
        return;
      }
      final map = Map<dynamic, dynamic>.from(data as Map);
      final seenBy = map['lastSeenBy'] as Map?;
      final seen = seenBy == null ? 0 : (seenBy[chat.otherUserId] ?? 0) as num;
      otherLastSeen.value = seen.toInt();
    });
  }

  Future<void> markSeen() async {
    final lastOtherMessageTime = messages
        .where((m) => m.senderId == chat.otherUserId)
        .fold<int>(0, (max, m) => m.messageTime > max ? m.messageTime : max);

    if (lastOtherMessageTime == 0) return;

    final myUid = user.id;

    final snap = await lastSeenByRef.child(myUid).get();
    final current = snap.value == null ? 0 : (snap.value as num).toInt();

    if (lastOtherMessageTime <= current) return;

    await lastSeenByRef.child(myUid).set(lastOtherMessageTime);
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    _messagesSubscription?.cancel();
    _childRemovedSub?.cancel();
    focusNode.dispose();
    _metaSubscription?.cancel();
    super.onClose();
  }
}
