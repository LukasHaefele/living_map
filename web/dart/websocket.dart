import 'package:living_map/actions.dart';
import 'package:web_socket_channel/html.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart';

import 'dart:html';

import 'actionhandler.dart';
import 'login.dart';

class ClientWebSocket {
  final WebSocket _webSocket = WebSocket('ws://localhost:7070/ws');

  void connect() async {
    messageStream.listen((data) async {
      getaction(parseData(data), this);
    });
    //isLoggedIn(this);
  }

  Stream get messageStream => _webSocket.onMessage.map((event) => event.data);

  Future<void> send(data) async {
    print(data);
    _webSocket.send(data);
  }
}

ClientWebSocket ws = ClientWebSocket();

Map<String, dynamic> parseData(String data) {
  Map<String, dynamic> r = new Map();

  List<String> split;
  split = data.split('; ');
  //print(split);
  r['action'] = split[0];
  split.removeAt(0);

  for (int i = 0; i < split.length; i++) {
    List<String> par = split[i].split(': ');
    //print(par);
    r[par[0]] = par[1];
  }
  return r;
}

void initwebsocket(ClientWebSocket ws) {
  ws.connect();
  //isLoggedIn(ws);
}
