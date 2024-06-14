import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class ConnectWebSocket extends ChatEvent {
  final String sessionId;

  const ConnectWebSocket(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

class SendMessage extends ChatEvent {
  final String message;
  final String sessionId;

  const SendMessage(this.message, this.sessionId);

  @override
  List<Object?> get props => [message, sessionId];
}

class ReceiveMessage extends ChatEvent {
  final String message;
  final String sessionId;

  const ReceiveMessage(this.message, this.sessionId);

  @override
  List<Object?> get props => [message, sessionId];
}

class LoadSessions extends ChatEvent {}

class CreateNewSession extends ChatEvent {
  final String sessionId;

  const CreateNewSession(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

class EndSession extends ChatEvent {
  const EndSession();
}
