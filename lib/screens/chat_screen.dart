import 'dart:math';
import 'package:ayna_chat/blocs/chat_bloc.dart';
import 'package:ayna_chat/constants/text_const.dart';
import 'package:ayna_chat/events/chat_events.dart';
import 'package:ayna_chat/events/chat_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _currentSessionId;

  @override
  void initState() {
    super.initState();
    _createNewSessionAndConnect(); // Moved to a separate method
  }

  @override
  void dispose() {
    // TODO: implement dispose
    context.read<ChatBloc>().add(EndSession());
    super.dispose();
  }

  void _createNewSessionAndConnect() {
    final randomSessionId =
        Random().nextInt(999999999).toString().padLeft(12, '0');
    _currentSessionId = randomSessionId; // Update session ID
    context.read<ChatBloc>().add(CreateNewSession(randomSessionId));
    context.read<ChatBloc>().add(ConnectWebSocket(randomSessionId));
  }

  void _sendMessage() {
    final message = _controller.text;
    if (message.isNotEmpty && _currentSessionId != null) {
      context.read<ChatBloc>().add(SendMessage(message, _currentSessionId!));
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat', style: kSubHeadingTextStyle.copyWith(fontSize: 20)),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatMessageReceived) {
                  // Updated state handling
                  return ListView.builder(
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      return ListTile(
                        title: Text(message.content),
                        subtitle: Text(
                            '${message.sender} @ ${message.timestamp.toLocal()}'),
                      );
                    },
                  );
                } else if (state is ChatSessionCreated) {
                  _currentSessionId = state.session.id;
                  return Center(child: Text('Session created'));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Enter message'),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
