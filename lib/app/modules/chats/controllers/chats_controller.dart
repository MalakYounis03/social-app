import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/app/constants/end_points.dart';
import 'package:social_app/app/data/user_model.dart';
import 'package:social_app/app/modules/chat_details/model/chat_model.dart';
import 'package:social_app/app/modules/search/model/people_response.dart';
import 'package:social_app/app/services/api_services.dart';
import 'package:social_app/app/services/auth_services.dart';

class ChatsController extends GetxController {
  final db = FirebaseDatabase.instance.ref();
  final authServices = Get.find<AuthServices>();
  late final user = authServices.user.value!;
  final chats = <Chat>[].obs;
  final isLoading = false.obs;
  StreamSubscription<DatabaseEvent>? _ref;
  StreamSubscription<DatabaseEvent>? _changedSub;
  StreamSubscription<DatabaseEvent>? _removedSub;

  final searchController = TextEditingController();
  final query = ''.obs;
  final people = <UserModel>[].obs;
  final apiServices = Get.find<ApiServices>();

  @override
  void onInit() {
    searchController.addListener(_onChanged);
    fetchPeople();
    fetchChats();
    super.onInit();
  }

  void _onChanged() => query.value = searchController.text.trim();

  void clearSearch() {
    searchController.clear();
    query.value = '';
  }

  List<Chat> get filteredChats {
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

  Future<void> fetchPeople() async {
    isLoading.value = true;

    try {
      final response = await apiServices.get(
        endPoint: EndPoints.getUsers,
        fromJson: UsersResponse.fromJson,
      );
      people.value = response.users;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load people: $e');
    }
    isLoading.value = false;
  }

  fetchChats() async {
    isLoading.value = true;
    final event = await db
        .child("list-of-chats/${user.id}")
        .orderByChild("lastMessageTime")
        .limitToLast(10)
        .once(DatabaseEventType.value);
    final childrens = event.snapshot.children.toList().reversed.toList();
    for (var child in childrens) {
      final chat = Chat.fromJson(
        child.key!,
        child.value as Map<dynamic, dynamic>,
      );
      chats.add(chat);
    }
    isLoading.value = false;
    listenForUpdates();
  }

  void listenForUpdates() {
    _ref?.cancel();
    _changedSub?.cancel();
    _removedSub?.cancel();

    final baseRef = db
        .child("list-of-chats/${user.id}")
        .orderByChild("lastMessageTime");

    // ✅ إذا فاضيين لا تستخدم startAfter
    final q = chats.isEmpty
        ? baseRef
        : baseRef.startAfter(chats.last.lastMessageTime);

    _ref = q.onChildAdded.listen((event) {
      final key = event.snapshot.key;
      final data = event.snapshot.value;

      if (key == null || data == null) return;

      final newChat = Chat.fromJson(key, data as Map<dynamic, dynamic>);

      // حدّث/انقل المحادثة للأول
      final index = chats.indexWhere(
        (c) => c.otherUserId == newChat.otherUserId,
      );
      if (index != -1) chats.removeAt(index);

      chats.insert(0, newChat);
    });

    _changedSub = baseRef.onChildChanged.listen((event) {
      final key = event.snapshot.key;
      final data = event.snapshot.value;

      if (key == null || data == null) return;

      final updatedChat = Chat.fromJson(key, data as Map<dynamic, dynamic>);

      final index = chats.indexWhere(
        (c) => c.otherUserId == updatedChat.otherUserId,
      );
      if (index != -1) {
        chats[index] = updatedChat;

        // (اختياري) لو بدك أي تحديث يطلعها للأول مثل واتساب:
        final item = chats.removeAt(index);
        chats.insert(0, item);
      }
    });

    _removedSub = baseRef.onChildRemoved.listen((event) {
      final key = event.snapshot.key;
      if (key == null) return;
      chats.removeWhere((c) => c.otherUserId == key);
    });
  }

  List<UserModel> get peopleExceptMe {
    return people
        .asMap()
        .entries
        .where((entry) {
          final index = entry.key;
          final userItem = entry.value;

          return userItem.id != user.id &&
              index != 1 &&
              index != 2 &&
              index != 3;
        })
        .map((e) => e.value)
        .toList();
  }

  @override
  void onClose() {
    searchController.removeListener(_onChanged);
    searchController.dispose();
    _ref?.cancel();
    _changedSub?.cancel();
    _removedSub?.cancel();
    super.onClose();
  }
}
