import 'package:get/get.dart';

class UnreadManager {
  // يحمل ال id للشخص اللي شاته مفتوحة حاليا ممكن تكون  null  ازا مش داخلة شات اي حد
  final RxnString currentOpenOtherId;
  UnreadManager({required this.currentOpenOtherId});

  final RxMap<String, int> unreadByChat = <String, int>{}.obs;
  final RxInt totalUnread = 0.obs;
  final Map<String, int> _lastHandledTimeByChat = {};
  // للتفرقة بين الشاتس القديمة والجديدة عند فتح التطبيق لاول مرة واستدعاء المسجات
  bool _initialUnreadHydrated = false;
  void reset() {
    unreadByChat.clear();
    totalUnread.value = 0;
    _lastHandledTimeByChat.clear();
    _initialUnreadHydrated = false;
  }

  void hydrateInitialChat({
    required String otherId,
    required Map<dynamic, dynamic> raw,
  }) {
    final unread = (raw['unreadCount'] as num?)?.toInt() ?? 0;
    unreadByChat[otherId] = unread;

    final lastTime = (raw['lastMessageTime'] as num?)?.toInt() ?? 0;
    _lastHandledTimeByChat[otherId] = lastTime;
  }

  void finishHydration() {
    _recalcTotalUnread();
    _initialUnreadHydrated = true;
  }

  void removeChat(String otherId) {
    unreadByChat.remove(otherId);
    _lastHandledTimeByChat.remove(otherId);
    _recalcTotalUnread();
  }

  void setChatReadUI(String otherId) {
    unreadByChat[otherId] = 0;
    _recalcTotalUnread();
  }

  void _recalcTotalUnread() {
    totalUnread.value = unreadByChat.values.where((v) => v > 0).length;
  }

  void handleUnreadUpdate({
    required String otherId,
    required Map<dynamic, dynamic> raw,
  }) {
    if (!_initialUnreadHydrated) return;

    final lastTime = (raw['lastMessageTime'] as num?)?.toInt() ?? 0;
    final prevTime = _lastHandledTimeByChat[otherId] ?? 0;

    if (lastTime <= prevTime) return;

    _lastHandledTimeByChat[otherId] = lastTime;

    if (currentOpenOtherId.value == otherId) {
      unreadByChat[otherId] = 0;
    } else {
      unreadByChat[otherId] =
          (raw['unreadCount'] as num?)?.toInt() ?? 0; // ✅ من DB
    }

    _recalcTotalUnread();
  }
}
