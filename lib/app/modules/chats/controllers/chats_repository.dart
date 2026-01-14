import 'package:firebase_database/firebase_database.dart';

class ChatsRepository {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();
  final String userId;
  ChatsRepository({required this.userId});
  Query _baseQuery() {
    return _db.child('list-of-chats/$userId').orderByChild('lastMessageTime');
  }

  Future<List<DataSnapshot>> fetchInitialChats({int limit = 10}) async {
    final event = await _baseQuery()
        .limitToLast(limit)
        .once(DatabaseEventType.value);
    return event.snapshot.children.toList().reversed.toList();
  }

  Stream<DatabaseEvent> listenAdded({int? startAfter}) {
    final q = (startAfter == null)
        ? _baseQuery()
        : _baseQuery().startAfter(startAfter);

    return q.onChildAdded;
  }

  Stream<DatabaseEvent> listenChanged() {
    return _baseQuery().onChildChanged;
  }

  Stream<DatabaseEvent> listenRemoved() {
    return _baseQuery().onChildRemoved;
  }

  Future<bool> markChatAsRead(String otherUserId) async {
    final chatRef = _db.child("list-of-chats/$userId/$otherUserId");
    final chatSnap = await chatRef.get();
    if (!chatSnap.exists) return false;
    final data = Map<dynamic, dynamic>.from(chatSnap.value as Map);
    final lastMsgTime = (data['lastMessageTime'] as num?)?.toInt() ?? 0;
    if (lastMsgTime == 0) return false;
    final now = DateTime.now().millisecondsSinceEpoch;
    await chatRef.update({'unreadCount': 0, 'lastReadTime': now});
    return true;
  }
}
