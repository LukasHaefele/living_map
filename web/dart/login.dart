import 'dart:html';
import 'package:living_map/user.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'file_picker.dart';
import 'map_selection.dart';
import 'panel.dart';
import 'websocket.dart';

void initloginpage(ClientWebSocket ws) {
  //querySelector('.greyout')?.style.display = 'flex';
  hidepanel('#registerpanel');
  showpanel('#loginpanel');
  querySelector('#login')?.onClick.listen((event) {
    String username =
        (document.getElementById('username') as InputElement).value as String;
    String password =
        (document.getElementById('password') as InputElement).value as String;
    String send =
        "account_login; username: " + username + "; password: " + password;
    //print(send);
    ws.send(send);
  });
  querySelector('#registerp')?.onClick.listen((event) {
    hidepanel('#loginpanel');
    showpanel('#registerpanel');
    querySelector('#register')?.onClick.listen((event) {
      String username = (document.getElementById('usernamer') as InputElement)
          .value as String;
      String pass1 =
          (document.getElementById('pass1') as InputElement).value as String;
      String pass2 =
          (document.getElementById('pass2') as InputElement).value as String;
      String email =
          (document.getElementById('email') as InputElement).value as String;
      //print(pass1);
      //print(pass2);

      if (pass1 == pass2) {
        String send = "account_register; username: " +
            username +
            "; password: " +
            pass1 +
            "; email: " +
            email;
        ws.send(send);
      } else {
        //querySelector('#')
        error('Passwords did not match match');
      }
    });
  });
}

void loggedIn(String username, ClientWebSocket ws) {
  hidepanel('#registerpanel');
  hidepanel('#loginpanel');
  querySelector('#accountbutton')?.remove();
  querySelector('#account')
    ?..text = username
    ..style.display = 'flex';
  initMapSelection(ws);
}

void isLoggedIn(ClientWebSocket ws) {
  //await Future.delayed(Duration(seconds: 1));
  String token;
  final Storage ls = window.localStorage;
  if (ls.containsKey('token')) {
    token = ls['token']!;
    //print(token);
    ws.send('token_login; token: ' + token);
  }
}

void saveToken(String token) {
  final Storage ls = window.localStorage;
  ls['token'] = token;
  print('saved token to local storage');
}

void invalidate() {
  final Storage ls = window.localStorage;
  ls.remove('token');
}

void updateProfilePicture(String src, ClientWebSocket ws) {
  //print(src);
  String ts = DateTime.now().millisecondsSinceEpoch.toString();
  querySelector('#profilePicture')
    ?..style.background = 'url($src?$ts)'
    ..style.display = 'flex'
    //..style.border = 'none'
    ..style.backgroundSize = 'contain'
    ..onClick.listen((event) {
      initFilePicker(ws);
    });
}
