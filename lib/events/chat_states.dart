import 'package:ayna_chat/chat_message.dart';
import 'package:ayna_chat/chat_session.dart';
import 'package:equatable/equatable.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatConnecting extends ChatState {}

class ChatConnected extends ChatState {}

class ChatMessageSent extends ChatState {}

class ChatMessageReceived extends ChatState {
  final List<ChatMessage> messages;

  const ChatMessageReceived(this.messages);

  @override
  List<Object?> get props => [messages];
}

class ChatSessionsLoaded extends ChatState {
  final List<ChatSession> sessions;

  const ChatSessionsLoaded(this.sessions);

  @override
  List<Object?> get props => [sessions];
}

class ChatSessionCreated extends ChatState {
  final ChatSession session;

  const ChatSessionCreated(this.session);

  @override
  List<Object?> get props => [session];
}

class ChatSessionEnded extends ChatState {}
