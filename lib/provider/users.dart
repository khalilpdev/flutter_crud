import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_crud/models/user.dart';
import 'package:http/http.dart' as http;

/// aula de refencia
/// https://youtu.be/Z-uJPNk0Moo
/// https://youtu.be/Z-uJPNk0Moo?t=818

class Users with ChangeNotifier {
  static const _baseUrl =
      'https://crud-teste-34564-default-rtdb.firebaseio.com/';

  final Map<String, User> _items = Map();

  void get loadFromFirebase async {
    var uri = Uri.parse("$_baseUrl/users.json");

    try {
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        var fireBaseUsers = jsonDecode(response.body) as Map<String, dynamic>;

        fireBaseUsers.forEach((key, value) {
          User user = User.fromMap(value);
          user.id = key;
          _items.putIfAbsent(key, () => user);
        });
      } else {
        print('Erro ao obter dados do firebase');
      }

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  int get count {
    return _items?.length;
  }

  User byIndex(int i) {
    return _items?.values?.elementAt(i);
  }

  Future<void> put(User user) async {
    if (user == null) {
      return;
    }

    if (user.id != null) {
      var uri = Uri.parse("$_baseUrl/users/${user.id}.json");
      final response = await http.patch(uri,
          body: json.encode(
            {
              'name': user.name.trim(),
              'email': user.email.trim(),
              'avatarUrl': user.avatarUrl.trim()
            },
          ));

      print(json.decode(response.body));
    } else {
      var uri = Uri.parse("$_baseUrl/users.json");
      final response = await http.post(uri,
          body: json.encode(
            {
              'name': user.name,
              'email': user.email,
              'avatarUrl': user.avatarUrl
            },
          ));

      final newId = json.decode(response.body)['name'];
      user.id = newId;
      print(json.decode(response.body));
    }

    _items.putIfAbsent(
        user.id,
        () => User(
              id: user.id,
              name: user.name.trim(),
              email: user.email.trim(),
              avatarUrl: user.avatarUrl.trim(),
            ));

    notifyListeners();
  }

  void remove(User user) async {
    if (user == null || user.id == null) {
      return;
    }

    var uri = Uri.parse("$_baseUrl/users/${user.id}.json");
    try {
      await http.delete(uri);
      _items.remove(user.id);

      notifyListeners();
    } catch (e) {
      print('Erro ao remover do firebase [$e]');
    }
  }
}
