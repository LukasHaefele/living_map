import 'dart:convert';

import 'dart:io';

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

void addToken() {}

void saveTokens() {
  List<dynamic> st = [];
  for (int i = 0; i < allTokens.length; i++) {
    st.add(allTokens[i].toJson());
  }
  String s = jsonEncode(st);
  File file = File('.data/token.json');
  file.writeAsString(s);
}

List<Token> getTokens() {
  List<Token> r = [];
  List<dynamic> st = [];

  File file = File('.data/token.json');
  String s = file.readAsStringSync();
  if (s.isNotEmpty) {
    st = jsonDecode(s);
  }

  for (int i = 0; i < st.length; i++) {
    Token u = tokenFromJson(st[i]);
    r.add(u);
  }

  return r;
}
