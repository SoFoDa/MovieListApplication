
import 'package:web_socket_channel/io.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

class Websocket {
  static final Websocket _sockets = new Websocket._internal();
  ObserverList<Function> _listeners = new ObserverList<Function>();
  var _channel;

  factory Websocket(){
    return _sockets;
  }

  Websocket._internal();  

  // Connection established
  bool _connected = false;
    
  // Initialize websocket connection  
  initCommunication() async {        
    close();    
    try {
      _channel = new IOWebSocketChannel.connect("ws://localhost:8989");      
      _channel.stream.listen(_onReception);
      _connected = true;
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
  send(Map<String, dynamic> message){ 
    if (_channel != null){
      if (_channel.sink != null && _connected) {
        String json = jsonEncode(message);
        print("Sending: " + json);
        _channel.sink.add(json);
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
    print("LENGTH: =====" + _listeners.length.toString());
    _listeners.forEach((Function callback){
      callback(message);
    });
  }
}

