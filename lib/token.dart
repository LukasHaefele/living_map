import 'dart:convert';
import 'dart:io';

import 'package:web_socket_channel/web_socket_channel.dart';

class Token {
  late int id;
  late String type;
  late String name;
  late String info;
  late String picture;
  late List<String> pred;
  late List<String> prey;
  late int wealth;
  late int wealthIncrease;
  late int health;
  late int strength;
  late int numbers;
  late int aggression;
  late String vendetta;
  late int intelligence;
  late Map<dynamic, dynamic> warState;
  late Map<int, int> position;

  Token(
      this.id,
      this.type,
      this.name,
      this.info,
      this.picture,
      this.pred,
      this.prey,
      this.wealth,
      this.wealthIncrease,
      this.strength,
      this.aggression,
      this.vendetta,
      this.intelligence,
      this.warState,
      this.position);

  Map toJson() {
    Map m = {
      'id': id,
      'type': type,
      'name': name,
      'info': info,
      'picture': picture,
      'pred': pred,
      'prey': prey,
      'wealth': wealth,
      'wealthIncrease': wealthIncrease,
      'strength': strength,
      'aggression': aggression,
      'vendetta': vendetta,
      'intelligence': intelligence,
      'warState': warState,
      'position': position
    };
    return m;
  }
}

Token tokenFromJson(Map token) {
  return Token(
      token['id'],
      token['type'],
      token['name'],
      token['info'],
      token['picture'],
      token['pred'],
      token['prey'],
      token['wealth'],
      token['wealthIncrease'],
      token['strength'],
      token['aggression'],
      token['vendetta'],
      token['intelligence'],
      token['warState'],
      token['position']);
}

List<Token> allTokens = getTokens();

int createToken(Map token, WebSocketChannel wsc) {
  Token newToken = Token(
      token['id'],
      token['type'],
      token['name'],
      token['info'],
      token['picture'],
      token['pred'],
      token['prey'],
      token['wealth'],
      token['wealthIncrease'],
      token['strength'],
      token['aggression'],
      token['vendetta'],
      token['intelligence'],
      token['warState'],
      token['position']);
  allTokens.add(newToken);
  saveTokens();
  sendToken(newToken, wsc);
  return token['id'];
}

void saveTokens() {
  List<dynamic> st = [];
  for (var element in allTokens) {
    st.add(element.toJson());
  }
  String s = jsonEncode(st);
  File file = File('.data/token.json');
  file.writeAsString(s);
}

List<Token> getTokens() {
  List<Token> to = [];
  List<dynamic> us = [];
  File file = File('.data/token.json');
  String s = file.readAsStringSync();
  if (s.isNotEmpty) {
    us = jsonDecode(s);
  }
  for (var element in us) {
    to.add(tokenFromJson(element));
  }

  return to;
}

Token? getTokenById(int id) {
  for (var element in allTokens) {
    if (element.id == id) {
      return element;
    }
  }
  return null;
}

void sendToken(Token t, WebSocketChannel wsc) {
  String s = jsonEncode(t.toJson());
  wsc.sink.add('game_token_add; token: $s');
}
