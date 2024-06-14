import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  late WebSocketChannel _channel;
  final _controller =
      StreamController<String>.broadcast(); // Changed to .broadcast()

  Stream<String> get messages => _controller.stream;

  void connect() {
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://websocket.org/tools/websocket-echo-server'),
    );

    _channel.stream.listen((message) {
      _controller.add(message);
    });
  }

  void sendMessage(String message) {
    _channel.sink.add(message);
  }

  void disconnect() {
    _channel.sink.close();
    _controller.close();
  }
}
