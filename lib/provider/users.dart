import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_crud/data/dummy_users.dart';
import 'package:flutter_crud/models/user.dart';
import 'package:http/http.dart' as http;

/// aula de refencia
/// https://youtu.be/Z-uJPNk0Moo

class Users with ChangeNotifier {
  static const _baseUrl =
      'https://crud-teste-34564-default-rtdb.firebaseio.com/';

  final Map<String, User> _items = {...DUMMY_USERS};

  List<User> get all {
    return [..._items.values];
  }

  int get count {
    return _items.length;
  }

  User byIndex(int i) {
    return _items.values.elementAt(i);
  }

  // adiciona ou altera um usuario
  Future<void> put(User user) async {
    if (user == null) {
      return;
    }

    if (user.id != null &&
        user.id.trim().isNotEmpty &&
        _items.containsKey(user.id)) {
      _items.update(
          user.id,
          (_) => User(
                id: user.id,
                name: user.name.trim(),
                email: user.email.trim(),
                avatarUrl: user.avatarUrl.trim(),
              ));
    } else {
      var uri = Uri.parse("$_baseUrl/users.json");
      print(uri);
      final response = await http.post(uri,
          body: json.encode(
            {
              'name': user.name,
              'email': user.email,
              'avatarUrl': user.avatarUrl
            },
          ));

      final id = json.decode(response.body)['name'];
      print(json.decode(response.body));

      //final id = Random().nextDouble().toString();
      _items.putIfAbsent(
          id,
          () => User(
                id: id,
                name: user.name.trim(),
                email: user.email.trim(),
                avatarUrl: user.avatarUrl.trim(),
              ));
    }

    notifyListeners();
  }

  void remove(User user) {
    if (user != null && user.id != null) {
      _items.remove(user.id);
      notifyListeners();
    }
  }
}
