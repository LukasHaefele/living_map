import 'dart:html';

import 'package:living_map/actions.dart';
//import 'package:living_map/user.dart';

//import 'header.dart';
import 'login.dart';
import 'map_selection.dart';
import 'mapaction.dart';
import 'panel.dart';
import 'websocket.dart';

dynamic getaction(Map request, ClientWebSocket ws) {
  print(request);
  switch (request['action']) {
    case ACCOUNT_LOGIN:
      return;

    case CREATE_SUCCESS:
      loggedIn(request['username'], ws);
      return;

    case CREATE_FAILURE:
      error(
          'The registration failed, your email or username is already in use');
      return;

    case LOGIN_SUCCESS:
      loggedIn(request['username'], ws);
      return;

    case LOGIN_FAILURE:
      error('Password or username incorrect.');
      return;

    case TOKEN_SAVE:
      saveToken(request['token']);
      return;

    case TOKEN_INVALID:
      invalidate();
      return;

    case CONNECTION_OPENED:
      print('connection opened');
      isLoggedIn(ws);
      return;

    case PROFILE_PICTURE:
      updateProfilePicture(request['src'], ws);
      return;

    case MAP_ADD:
      addMap(request['name'], request['src'], int.parse(request['id']), ws);
      return;

    case ERROR:
      error(request['message']);
      return;

    case MAP_INITIALIZE:
      initMap(request['src']);
      return;

    case GAME_TOKEN_ADD:
      addTokenToMap(request['token']);
      return;
  }
  window.console.warn('unhandeled action ' + request['action']);
  //print(request);
}

Map remember = {};
