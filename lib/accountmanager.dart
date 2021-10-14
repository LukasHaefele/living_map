import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:living_map/user.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:image/image.dart';
//import 'package:flutter/widgets.dart';

List<User> allUsers = get_users();

bool createAccount(
    String username, String password, String email, WebSocketChannel wsc) {
  if (!is_taken(username, email)) {
    String token = getRandomString(8);
    while (tokenIsTaken(token)) {
      token = getRandomString(8);
    }
    User newuser = User(username, password, email, token, _rnd.nextInt(5),
        'img/profilePics/blank.png');
    //wsc.sink.add('token_save; token:' + newuser.token);
    allUsers.add(newuser);
    wsc.sink.add('token_save; token: ' + newuser.token);
    wsc.sink.add('profile_picture; src: ' + newuser.profilePicture);
    //newuser.encrypt();
    saveUsers();
    //print('penis');
    return true;
  }
  return false;
}

bool tokenIsTaken(String token) {
  bool r = false;

  for (int i = 0; i < allUsers.length; i++) {
    //allUsers[i].decrypt();
    if (token == allUsers[i].token) {
      //allUsers[i].encrypt();
      return true;
    }
    //allUsers[i].encrypt();
  }
  return r;
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

List<User> get_users() {
  List<User> r = [];
  List<dynamic> st = [];

  File file = File('.data/user.json');
  String s = file.readAsStringSync();
  if (s.isNotEmpty) {
    st = jsonDecode(s);
  }

  for (int i = 0; i < st.length; i++) {
    User u = userFromJson(st[i]);
    r.add(u);
  }

  return r;
}

void saveUsers() {
  List<dynamic> st = [];
  for (int i = 0; i < allUsers.length; i++) {
    st.add(allUsers[i].toJson());
  }
  String s = jsonEncode(st);
  File file = File('.data/user.json');
  file.writeAsString(s);
}

bool is_taken(String username, email) {
  for (int i = 0; i < allUsers.length; i++) {
    //allUsers[i].decrypt();
    if (username == allUsers[i].username || email == allUsers[i].email) {
      //allUsers[i].encrypt();
      return true;
    }
    //allUsers[i].encrypt();
  }
  return false;
}

bool login(String username, String password, WebSocketChannel ws) {
  for (int i = 0; i < allUsers.length; i++) {
    //allUsers[i].decrypt();
    if (allUsers[i].username == username && allUsers[i].password == password) {
      ws.sink.add('token_save; token: ' + allUsers[i].token);
      ws.sink.add('profile_picture; src: ' + allUsers[i].profilePicture);
      //allUsers[i].encrypt();
      return true;
    }
    //allUsers[i].encrypt();
  }
  return false;
}

Map tokenLog(String token, WebSocketChannel wsc) {
  Map m = {'bool': false};
  for (int i = 0; i < allUsers.length; i++) {
    //allUsers[i].decrypt();
    if (token == allUsers[i].token) {
      wsc.sink.add('profile_picture; src: ' + allUsers[i].profilePicture);
      m['bool'] = true;
      m['username'] = allUsers[i].username;
      //allUsers[i].encrypt();
      return m;
    }
    //allUsers[i].encrypt();
  }
  return m;
}

Map change_profle_picture(String username, String image) {
  Map m = {'bool': true};
  Uint8List bitlist = base64Decode(parseImage(image));
  Image img = copyResizeCropSquare(decodeImage(bitlist) as Image, 125);
  File('web/img/profilePics/$username.png').writeAsBytesSync(encodePng(img));
  m['src'] = 'img/profilePics/$username.png';
  update_user(username, 'img/profilePics/$username.png');

  saveUsers();

  return m;
}

String parseImage(String str) {
  String r = str.split('base64,')[1];

  return r;
}

void update_user(String username, String src) {
  for (int i = 0; i < allUsers.length; i++) {
    if (allUsers[i].username == username) {
      allUsers[i].profilePicture = src;
      return;
    }
  }
}