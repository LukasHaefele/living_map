import 'dart:convert';

import 'package:living_map/accountmanager.dart';
import 'package:living_map/mapworker.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:shelf/shelf.dart';
import 'actions.dart';

void onConnect(WebSocketChannel wsc) {
  //wsc.sink.add('cock');
  print('connection opened');
  wsc.sink.add('connection_opened');
  wsc.stream.listen((data) {
    //wsc.sink.add('penis');
    //print(data);
    getAction(parseData(data), wsc);
  }, onDone: () {
    print('connection closed');
  });
}

Map<String, dynamic> parseData(String data) {
  Map<String, dynamic> r = {};

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

dynamic getAction(Map<String, dynamic> request, WebSocketChannel wsc) async {
  String action = request['action'];
  if (request['action'] != PROFILE_PICTURE && request['action'] != MAP_UPLOAD) {
    print(request);
  } else {
    String un = request['username'];
    print('{action: picture_upload; username: $un');
  }
  switch (action) {
    case ACCOUNT_REGISTER:
      //print(request);
      if (createAccount(
          request['username'], request['password'], request['email'], wsc)) {
        wsc.sink.add('create_success; username: ' + request['username']);
        print('create_success; username: ' + request['username']);
      } else {
        wsc.sink.add('create_failure');
        print('create_failure');
      }
      return;

    case ACCOUNT_LOGIN:
      if (login(request['username'], request['password'], wsc)) {
        wsc.sink.add('login_success; username: ' + request['username']);
        print('login_success; username: ' + request['username']);
      } else {
        wsc.sink.add('login_failure');
        print('login_failure');
      }
      return;

    case TOKEN_LOGIN:
      Map m = tokenLog(request['token'], wsc);
      if (m['bool']) {
        wsc.sink.add('login_success; username: ' + m['username']);
        print('login_success; username: ' + m['username']);
      } else {
        wsc.sink.add('token_invalid');
        print('token_invalid');
      }
      return;

    case PROFILE_PICTURE:
      changeProflePicture(request['username'], request['pic'], wsc);
      return;

    case MAP_UPLOAD:
      createMap(request['name'], request['pic'], request['username'], wsc);
      return;

    case MAP_GET_ALL:
      getMapsForUser(request['username'], wsc);
      return;

    case MAP_SELECT:
      return;
  }
  print('Warning: unhandeled action');
}

/*(WebSocketChannel wsc) {
      wsc.sink.add('cock');
    })(request*/