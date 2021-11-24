import 'dart:html';

import 'websocket.dart';

void initMap(String src, ClientWebSocket ws) {
  querySelector('.mapSelection')
    ?..innerHtml = ''
    ..style.display = 'none';
  querySelector('.board')?.style.display = 'flex';
  ImageElement imE = querySelector('#boardImg')! as ImageElement;
  imE.src = src;
}

void addTokenToMap(String token) {}
