import 'package:ayna_chat/chat_message.dart';
import 'package:hive/hive.dart';

part 'chat_session.g.dart';

@HiveType(typeId: 1)
class ChatSession {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final List<ChatMessage> messages;

  @HiveField(2)
  final DateTime createdAt;

  ChatSession({
    required this.id,
    required this.messages,
    required this.createdAt,
  });
}
