import 'package:ayna_chat/blocs/authentication_bloc.dart';
import 'package:ayna_chat/blocs/chat_bloc.dart';
import 'package:ayna_chat/constants/text_const.dart';
import 'package:ayna_chat/events/authentication_events.dart';
import 'package:ayna_chat/events/chat_events.dart';
import 'package:ayna_chat/events/chat_states.dart';
import 'package:ayna_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    BlocProvider.of<ChatBloc>(context).add(LoadSessions());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authenticationBloc =
        BlocProvider.of<AuthenticationBloc>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/chat');
        },
        child: Icon(Icons.send),
      ),
      appBar: AppBar(
        title: Text('Home', style: kSubHeadingTextStyle.copyWith(fontSize: 20)),
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.chat),
          //   onPressed: () {},
          // ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              authenticationBloc.add(LoggedOut());
            },
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatSessionsLoaded) {
                  if (state.sessions.isEmpty) {
                    return const Center(child: Text('No sessions found'));
                  }
                  final session = state.sessions.first;
                  return state.sessions.isEmpty
                      ? const Center(child: Text('No sessions found'))
                      : ListView.builder(
                          itemCount: session.messages.length,
                          itemBuilder: (context, index) {
                            final message = session.messages[index];
                            return ListTile(
                              title: Text(message.content),
                              subtitle: Text(
                                  '${message.sender} at ${message.timestamp}'),
                            );
                          });
                } else if (state is ChatSessionCreated) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_rounded),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Chat session going on...",
                            style: kSubHeadingTextStyle.copyWith(fontSize: 16))
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: SizedBox(
                        height: 200,
                        width: 200,
                        child: Image.asset("assets/images/ayna_bg.png")),
                  );
                }
              },
            )),
          ),
          Container(
            height: double.infinity,
            width: 0.5,
            color: Colors.grey,
          ),
          Expanded(
            flex: 2,
            child: ChatScreen(),
          )
        ],
      ),
    );
  }
}
