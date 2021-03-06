import 'package:flutter/material.dart';
import 'package:flutter_crud/controllers/theme_controller.dart';
import 'package:flutter_crud/provider/users.dart';
import 'package:flutter_crud/routes/app_routes.dart';
import 'package:flutter_crud/views/user_form.dart';
import 'package:flutter_crud/views/user_list.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Users(),
        )
      ],
      child: MaterialApp(
          title: 'Flutter CRUD Demo',
          theme: ThemeData(
            primarySwatch: Colors.green,
            brightness: ThemeController.instance.isDarkTheme
                ? Brightness.dark
                : Brightness.light,
          ),
          themeMode: ThemeMode.dark,
          routes: {
            AppRoutes.HOME: (_) => Userlist(),
            AppRoutes.USER_FORM: (_) => UserForm(),
          }),
    );
  }
}
