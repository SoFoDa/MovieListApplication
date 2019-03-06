import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';

WebSocketConfig socket = new WebSocketConfig();

const String _server_address = "ws://localhost";

class WebSocketConfig {
  static final WebSocketConfig _sockets = new WebSocketConfig._internal();

  factory WebSocketConfig(){
    return _sockets;
  }

  WebSocketConfig._internal();  
  IOWebSocketChannel _channel;

  ObserverList<Function> _listeners = new ObserverList<Function>();

  // Connection established
  bool _connected = false;
    
  // Initialize websocket connection  
  initCommunication() async {        
    close();    
    try {
      _channel = new IOWebSocketChannel.connect(_server_address);      
      _channel.stream.listen(_onReception);
    } catch(e){
      // TODO error handling
    }
  }

  // Close websocket connection
  close(){
    if (_channel != null){
      if (_channel.sink != null){
        _channel.sink.close();
        _connected = false;
      }
    }
  }

  // Send websocket message  
  send(String message){
    if (_channel != null){
      if (_channel.sink != null && _connected){
        _channel.sink.add(message);
      }
    }
  }

  addListener(Function callback){
    _listeners.add(callback);
  }

  removeListener(Function callback){
    _listeners.remove(callback);
  }

  _onReception(message){
    _connected = true;
    _listeners.forEach((Function callback){
      callback(message);
    });
  }
}

