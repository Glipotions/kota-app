// ignore_for_file: inference_failure_on_function_return_type

import 'dart:async';
import 'dart:developer' show log;
import 'package:socket_io_client/socket_io_client.dart' as io;

/// Enum representing different statuses of the WebSocket connection.
enum SocketActivity {
  ///Enum that represen socket succesfully connected.
  onConnect,

  ///Enum that represen socket is connecting.
  onConnecting,

  ///Enum that represen socket has error.
  onError,

  ///Enum that represen socket has error while connecting.
  onConnectError,

  ///Enum that represen socket has timedout while conneting.
  onConnectTimeout,
}

///Function that uses [SocketActivity]
typedef OnStatusChange = Function(SocketActivity);

/// A class for managing WebSocket connections.
class AppSocket {
  /// Creates an instance of [AppSocket] with the specified [url],
  /// optional [header], and [onSocketStatusActivity] callback.
  AppSocket({
    required this.url,
    required this.onSocketStatusActivity,
    this.actions=const [],
    this.header,
  });

  /// WebSocket instance used for communication.
  io.Socket? _channel;

  /// The URL of the WebSocket server.
  final String url;
 ///
  final List<SocketChannelAction> actions;

  /// Optional headers to be included in the WebSocket connection.
  final Map<String, String>? header;

  ///Function that uses triggeres on socket status activity
  final OnStatusChange onSocketStatusActivity;

  /// Closes the WebSocket connection and releases associated resources.
  Future<void> close() async {
    _channel?.close();
    _channel = null;
    _log('close');
  }

  /// Initializes the WebSocket connection and sets up event listeners.
  Future<void> init() async {
    _log('connecting...');
    _channel = await _connectToSocket();
    _setSocketActivityActionsOnChange();
    _setSocketActionsForChannels();
    _log('socket connection initialized');
  }

  void _setSocketActivityActionsOnChange() {
    _channel!.onConnect(
      (data) => onSocketStatusActivity(SocketActivity.onConnect),
    );
    _channel!.onConnecting(
      (data) => onSocketStatusActivity(SocketActivity.onConnecting),
    );
    _channel!.onError(
      (data) => onSocketStatusActivity(SocketActivity.onError),
    );
    _channel!.onConnectError(
      (data) => onSocketStatusActivity(SocketActivity.onConnectError),
    );
    _channel!.onConnectTimeout(
      (data) => onSocketStatusActivity(SocketActivity.onConnectTimeout),
    );
  }

  void _setSocketActionsForChannels() {
    for (final element in actions) {
        _channel!.on(element.channel, element.action);
     }

  }

  /// Establishes a WebSocket connection to the specified URL
  ///  with optional headers.
  Future<io.Socket> _connectToSocket() async {
    try {
      _channel = io.io(
        url,
        io.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .setExtraHeaders(header ?? {})
            .build(),
      );
      return _channel!.connect();
    } catch (e) {
      _log('Error! cannot connect WS connectWs $e');
      await Future<Duration>.delayed(const Duration(seconds: 1));
      return _connectToSocket();
    }
  }

  /// Sends data to the WebSocket server.
  void send(String event, Map<String, dynamic> data) {
    _log('Sent Data: $data');
    _channel!.emit(event, data);
  }

  /// Internal logging function using the Dart developer log.
  void _log(String message) => log(message, name: 'socket');
}
///
class SocketChannelAction {
  ///
  SocketChannelAction({
    required this.channel,
    required this.action,
  });
///
  final String channel;
  ///
  final Function(dynamic) action;
}
