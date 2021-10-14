import 'dart:convert';
//import 'dart:html';

class User {
  late String username;
  late String password;
  late String email;
  late String token;
  late int key;
  late String profilePicture;
  bool encrypted = false;

  User(this.username, this.password, this.email, this.token, this.key,
      this.profilePicture);

  Map toJson() {
    var user = {
      'username': username,
      'password': password,
      'email': email,
      'token': token,
      'key': key,
      'profilePicture': profilePicture
    };

    return user;
  }

  /*void encrypt() {
    if (encrypted) {
      return;
    }
    List<int> enc = utf8.encode(username);
    for (int i = 0; i < enc.length; i++) {
      enc[i] += key;
    }
    print(enc);
    print(key);
    username = utf8.decode(enc);
    enc = utf8.encode(password);
    for (int i = 0; i < enc.length; i++) {
      enc[i] += key;
    }
    password = utf8.decode(enc);
    enc = utf8.encode(email);
    for (int i = 0; i < enc.length; i++) {
      enc[i] += key;
    }
    email = utf8.decode(enc);
    enc = utf8.encode(token);
    for (int i = 0; i < enc.length; i++) {
      enc[i] += key;
    }
    token = utf8.decode(enc);
    encrypted = true;
  }

  void decrypt() {
    if (!encrypted) {
      return;
    }
    List<int> enc = utf8.encode(username);
    for (int i = 0; i < enc.length; i++) {
      enc[i] -= key;
    }
    username = utf8.decode(enc);
    enc = utf8.encode(password);
    for (int i = 0; i < enc.length; i++) {
      enc[i] -= key;
    }
    password = utf8.decode(enc);
    enc = utf8.encode(email);
    for (int i = 0; i < enc.length; i++) {
      enc[i] -= key;
    }
    email = utf8.decode(enc);
    enc = utf8.encode(token);
    for (int i = 0; i < enc.length; i++) {
      enc[i] -= key;
    }
    token = utf8.decode(enc);
    encrypted = false;
  }*/
}

User userFromJson(Map user) {
  User r = User(user['username'], user['password'], user['email'],
      user['token'], user['key'], user['profilePicture']);
  return r;
}
