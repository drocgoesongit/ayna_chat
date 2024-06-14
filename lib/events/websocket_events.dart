// websocket_event.dart
import 'package:equatable/equatable.dart';

abstract class WebSocketEvent extends Equatable {
  const WebSocketEvent();

  @override
  List<Object> get props => [];
}

class ConnectWebSocket extends WebSocketEvent {
  final String sessionId;

  const ConnectWebSocket(this.sessionId);

  @override
  List<Object> get props => [sessionId];
}

class SendMessage extends WebSocketEvent {
  final String message;

  const SendMessage(this.message);

  @override
  List<Object> get props => [message];
}

class ReceiveMessage extends WebSocketEvent {
  final String message;

  const ReceiveMessage(this.message);

  @override
  List<Object> get props => [message];
}

class DisconnectWebSocket extends WebSocketEvent {}
