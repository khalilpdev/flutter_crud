import 'package:flutter/cupertino.dart';

class ThemeController extends ChangeNotifier {
  static ThemeController instance = ThemeController();

  bool isDarkTheme = true;

  changeTheme() {
    isDarkTheme = !isDarkTheme;
    notifyListeners();
  }
}
