import 'package:flutter/material.dart';
import 'package:haiererp/ui/page/login_page.dart';
import 'package:haiererp/ui/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Routes {
  // late 延迟初始化
  late SharedPreferences sharedPreferences;

  void realRunApp() async {
    // 初始化
    WidgetsFlutterBinding.ensureInitialized();
    runApp(MaterialApp(
      home: LoginPage(),
      routes: <String, WidgetBuilder>{
        "/login": (BuildContext context) => LoginPage(),
        "/register": (BuildContext context) => RegisterPage(),
      },
    ));
  }

  Routes() {
    realRunApp();
  }
}
