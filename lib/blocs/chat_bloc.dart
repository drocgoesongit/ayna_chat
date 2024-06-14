import 'package:ayna_chat/chat_session.dart';
import 'package:ayna_chat/blocs/websocket_service.dart';
import 'package:ayna_chat/chat_message.dart';
import 'package:ayna_chat/events/chat_events.dart';
import 'package:ayna_chat/events/chat_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final WebSocketService _webSocketService = WebSocketService();
  Box<ChatMessage>? _chatBox;
  Box<ChatSession>? _sessionBox;

  ChatBloc() : super(ChatInitial()) {
    on<ConnectWebSocket>(_onConnectWebSocket);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
    on<LoadSessions>(_onLoadSessions);
    on<CreateNewSession>(_onCreateNewSession);
    _openChatBox();
    _openSessionBox();
  }

  Future<void> _openChatBox() async {
    _chatBox = await Hive.openBox<ChatMessage>('chatMessages');
  }

  Future<void> _openSessionBox() async {
    _sessionBox = await Hive.openBox<ChatSession>('chatSessions');
  }

  void _onConnectWebSocket(ConnectWebSocket event, Emitter<ChatState> emit) {
    emit(ChatConnecting());
    _webSocketService.connect();
    _webSocketService.messages.listen((message) {
      add(ReceiveMessage(message, event.sessionId));
    });
    emit(ChatConnected());
  }

  void _onSendMessage(SendMessage event, Emitter<ChatState> emit) {
    _webSocketService.sendMessage(event.message);
    _saveMessage(event.message, 'me', event.sessionId);
    final messages = _getSessionMessages(event.sessionId);
    emit(ChatMessageReceived(messages)); // Emit updated state
  }

  void _onReceiveMessage(ReceiveMessage event, Emitter<ChatState> emit) {
    _saveMessage(event.message, 'server', event.sessionId);
    final messages = _getSessionMessages(event.sessionId);
    emit(ChatMessageReceived(messages)); // Emit updated state
  }

  Future<void> _onLoadSessions(
      LoadSessions event, Emitter<ChatState> emit) async {
    final sessions = _sessionBox!.values.toList();
    emit(ChatSessionsLoaded(sessions));
  }

  Future<void> _onCreateNewSession(
      CreateNewSession event, Emitter<ChatState> emit) async {
    final newSession = ChatSession(
      id: event.sessionId,
      messages: [],
      createdAt: DateTime.now(),
    );
    await _sessionBox!.put(event.sessionId, newSession);
    emit(ChatSessionCreated(newSession));
  }

  void _saveMessage(String content, String sender, String sessionId) {
    final message = ChatMessage(
        content: content, sender: sender, timestamp: DateTime.now());
    _chatBox?.add(message);
    final session = _sessionBox?.get(sessionId);
    session?.messages.add(message);
    _sessionBox?.put(sessionId, session!); // Update session in the box
  }

  List<ChatMessage> _getSessionMessages(String sessionId) {
    final session = _sessionBox?.get(sessionId);
    return session?.messages ?? [];
  }

  // @override
  // Future<void> close() {
  //   _webSocketService.disconnect();
  //   return super.close();
  // }
}
