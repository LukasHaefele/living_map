import 'dart:html';
//import 'package:living_map/user.dart';
//import 'package:web_socket_channel/web_socket_channel.dart';

import 'login.dart';
import 'websocket.dart';

void initheader(ClientWebSocket ws) {
  querySelector('#accountbutton')
    ?..querySelector('p')?.text = 'login'
    ..onClick.listen((event) {
      initloginpage(ws);
    });
}
