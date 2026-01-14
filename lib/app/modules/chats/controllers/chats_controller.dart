import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/app/constants/end_points.dart';
import 'package:social_app/app/data/user_model.dart';
import 'package:social_app/app/modules/chats/controllers/chats_repository.dart';
import 'package:social_app/app/modules/chats/controllers/unread_manager.dart';
import 'package:social_app/app/modules/chats/model/chat_model.dart';
import 'package:social_app/app/modules/search/model/people_response.dart';
import 'package:social_app/app/services/api_services.dart';
import 'package:social_app/app/services/auth_services.dart';

class ChatsController extends GetxController {
  final authServices = Get.find<AuthServices>();
  final apiServices = Get.find<ApiServices>();

  late final user = authServices.user.value!;
  late final ChatsRepository _repo;

  final chats = <Chat>[].obs;
  final people = <UserModel>[].obs;

  final isLoading = false.obs;

  final searchController = TextEditingController();
  final query = ''.obs;

  final RxnString currentOpenOtherId = RxnString();

  late final UnreadManager unread;

  StreamSubscription<DatabaseEvent>? _addedSub;
  StreamSubscription<DatabaseEvent>? _changedSub;
  StreamSubscription<DatabaseEvent>? _removedSub;

  @override
  void onInit() {
    super.onInit();
    _repo = ChatsRepository(userId: user.id);
    unread = UnreadManager(currentOpenOtherId: currentOpenOtherId);
    searchController.addListener(_onChanged);
    fetchPeople();
    fetchChats();
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

  Future<void> fetchChats() async {
    isLoading.value = true;
    try {
      final snaps = await _repo.fetchInitialChats(limit: 10);

      chats.clear();
      unread.reset();
      for (var snap in snaps) {
        final key = snap.key;
        final value = snap.value;
        if (key == null || value == null) continue;
        final map = Map<dynamic, dynamic>.from(value as Map);

        final chat = Chat.fromJson(key, map);
        chats.add(chat);
        unread.hydrateInitialChat(otherId: key, raw: map);
      }
      unread.finishHydration();
      listenForUpdates();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load chats: $e');
    }
    isLoading.value = false;
  }

  void listenForUpdates() {
    _cancelSubs();
    final startAfter = chats.isEmpty ? null : chats.last.lastMessageTime;

    _addedSub = _repo.listenAdded(startAfter: startAfter).listen((event) {
      final key = event.snapshot.key;
      final data = event.snapshot.value;

      if (key == null || data == null) return;
      final map = Map<dynamic, dynamic>.from(data as Map);

      final newChat = Chat.fromJson(key, map);
      _upsert(newChat, moveToTop: true);
      unread.handleUnreadUpdate(otherId: key, raw: map);
    });

    _changedSub = _repo.listenChanged().listen((event) {
      final key = event.snapshot.key;
      final data = event.snapshot.value;

      if (key == null || data == null) return;
      final map = Map<dynamic, dynamic>.from(data as Map);
      final updatedChat = Chat.fromJson(key, map);

      final index = chats.indexWhere(
        (c) => c.otherUserId == updatedChat.otherUserId,
      );

      // ✅ بس طلّعها للأول إذا lastMessageTime زاد (رسالة جديدة)
      bool moveToTop = false;
      if (index != -1) {
        final oldTime = chats[index].lastMessageTime;
        final newTime = updatedChat.lastMessageTime;
        moveToTop = newTime > oldTime;
      } else {
        // مش موجودة عندك (limitToLast)، خليها تنضاف للأول
        moveToTop = true;
      }

      _upsert(updatedChat, moveToTop: moveToTop);

      unread.handleUnreadUpdate(otherId: key, raw: map);
    });

    _removedSub = _repo.listenRemoved().listen((event) {
      final key = event.snapshot.key;
      if (key == null) return;
      chats.removeWhere((c) => c.otherUserId == key);
      unread.removeChat(key);
    });
  }

  // لما افتح الشات ديتيلز يترجعلي ال otherUserId ولما اطلع من الشات بترجعلي null
  void setOpenChat(String? otherUserId) {
    currentOpenOtherId.value = otherUserId;
  }

  Future<void> markChatAsRead(String otherUserId) async {
    try {
      final success = await _repo.markChatAsRead(otherUserId);
      if (!success) return;
      unread.setChatReadUI(otherUserId);
    } catch (e) {
      Get.snackbar('Error', 'Failed to mark chat as read: $e');
    }
  }

  void _upsert(Chat chat, {required bool moveToTop}) {
    final index = chats.indexWhere((c) => c.otherUserId == chat.otherUserId);
    if (index != -1) {
      chats[index] = chat;
      if (moveToTop) {
        final item = chats.removeAt(index);
        chats.insert(0, item);
      }
    } else {
      chats.insert(0, chat);
    }
  }

  void _cancelSubs() {
    try {
      _addedSub?.cancel();
    } catch (_) {}
    try {
      _changedSub?.cancel();
    } catch (_) {}
    try {
      _removedSub?.cancel();
    } catch (_) {}

    _addedSub = null;
    _changedSub = null;
    _removedSub = null;
  }

  @override
  void onClose() {
    searchController.removeListener(_onChanged);
    searchController.dispose();
    _cancelSubs();
    super.onClose();
  }
}
