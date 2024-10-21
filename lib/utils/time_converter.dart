String formatTime(dynamic unixTime) {
  int timestamp;

  // Check if unixTime is of type String
  if (unixTime is String) {
    timestamp = int.tryParse(unixTime) ?? 0; // Parse to int or fallback to 0
  } else if (unixTime is int) {
    timestamp = unixTime; // Use directly if it's already an int
  } else {
    return 'Invalid time'; // Handle unsupported types
  }

  final DateTime dateTime =
      DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  final Duration difference = DateTime.now().difference(dateTime);

  if (difference.inDays > 0) {
    return '${difference.inDays} days ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} hours ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} minutes ago';
  } else {
    return 'Just now';
  }
}
