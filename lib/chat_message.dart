import 'package:hive/hive.dart';

part 'chat_message.g.dart';

@HiveType(typeId: 0)
class ChatMessage {
  @HiveField(0)
  final String content;

  @HiveField(1)
  final String sender;

  @HiveField(2)
  final DateTime timestamp;

  ChatMessage({
    required this.content,
    required this.sender,
    required this.timestamp,
  });
}
