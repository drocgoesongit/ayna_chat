import 'dart:async';
import 'package:ayna_chat/chat_message.dart';
import 'package:ayna_chat/events/websocket_events.dart';
import 'package:ayna_chat/events/websocket_states.dart';
import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketBloc extends Bloc<WebSocketEvent, WebSocketState> {
  WebSocketChannel? _channel;
  final Box<ChatMessage> _chatBox = Hive.box<ChatMessage>('chatMessages');

  WebSocketBloc() : super(WebSocketInitial()) {
    on<ConnectWebSocket>(_onConnectWebSocket);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
  }

  void _onConnectWebSocket(
      ConnectWebSocket event, Emitter<WebSocketState> emit) {
    _channel = WebSocketChannel.connect(
        Uri.parse('wss://websocket.org/tools/websocket-echo-server'));
    _channel!.stream.listen((message) {
      add(ReceiveMessage(message));
    });
    emit(WebSocketConnected());
  }

  void _onSendMessage(SendMessage event, Emitter<WebSocketState> emit) {
    if (_channel != null) {
      _channel!.sink.add(event.message);
    }
  }

  void _onReceiveMessage(ReceiveMessage event, Emitter<WebSocketState> emit) {
    final message = ChatMessage(
        content: event.message, sender: "server", timestamp: DateTime.now());
    _chatBox.add(message);
    emit(WebSocketMessageReceived(message: event.message));
  }

  // @override
  // Future<void> close() {
  //   _channel?.sink.close();
  //   return super.close();
  // }
}
