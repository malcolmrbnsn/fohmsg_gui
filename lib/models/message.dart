class Message {
  final String date;
  final String text;
  final String userID;
  final String messageID;

  const Message({
    required this.date,
    required this.text,
    required this.userID,
    required this.messageID,
  });

  // factory Message.fromSocket(DocumentSnapshot)
}
