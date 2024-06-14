import 'package:ayna_chat/blocs/authentication_bloc.dart';
import 'package:ayna_chat/blocs/chat_bloc.dart';
import 'package:ayna_chat/chat_session.dart';
import 'package:ayna_chat/blocs/websocket_bloc.dart';
import 'package:ayna_chat/chat_message.dart';
import 'package:ayna_chat/events/authentication_events.dart';
import 'package:ayna_chat/events/authentication_state.dart';
import 'package:ayna_chat/events/chat_states.dart';
import 'package:ayna_chat/firebase_options.dart';
import 'package:ayna_chat/screens/chat_screen.dart';
import 'package:ayna_chat/screens/home_page.dart';
import 'package:ayna_chat/screens/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ChatMessageAdapter());
  Hive.registerAdapter(ChatSessionAdapter());
  await Hive.openBox<ChatMessage>('chatMessages');
  await Hive.openBox<ChatSession>('chatSessions');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc()..add(AppStarted()),
        ),
        BlocProvider<WebSocketBloc>(
          create: (context) => WebSocketBloc(),
        ),
        BlocProvider<ChatBloc>(
          create: (context) => ChatBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter BLoC Chat App',
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is AuthenticationAuthenticated) {
              return HomePage();
            }
            if (state is AuthenticationUnauthenticated) {
              return HomePage();
            }
            if (state is AuthenticationLoading) {
              return LoadingIndicator();
            }
            return SplashScreen();
          },
        ),
        routes: {
          '/chat': (context) => ChatScreen(),
        },
      ),
    );
  }
}
