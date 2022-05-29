part of 'conn_bloc.dart';

@immutable
abstract class TcpEvent {}

/// Represents a request for a connection to a server.
class Connect extends TcpEvent {
  /// The host of the server to connect to.
  final dynamic host;

  /// The port of the server to connect to.
  final int port;

  Connect({required this.host, required this.port})
      : assert(host != null),
        assert(port != null);
}

/// Represents a request to disconnect from the server or abort the current connection request.
class Disconnect extends TcpEvent {}

/// Represents a socket error.
class ErrorOccured extends TcpEvent {}

/// Represents the event of an incoming message from the TCP server.
class MessageReceived extends TcpEvent {
  final Iterable<int> message;

  MessageReceived({required this.message});
}

/// Represents a request to send a message to the TCP server.
class SendMessage extends TcpEvent {
  /// The message to be sent to the TCP server.
  final Uint8List message;

  SendMessage({required this.message});
}

class EnableEncryption extends TcpEvent {
}


