String formatPostTime(DateTime createdAt) {
  final now = DateTime.now();
  final difference = now.difference(createdAt);

  if (difference.inSeconds < 60) {
    return 'Now';
  } else if (difference.inMinutes < 60) {
    return ' ${difference.inMinutes} minutes ago';
  } else if (difference.inHours < 24) {
    return ' ${difference.inHours} hours ago';
  } else {
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }
}
