import 'package:blog_app/constants/constants.dart';
import 'package:blog_app/screens/auth_screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPrefConstant.sharedPreferences = await SharedPreferences.getInstance();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Blog App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryColor: const Color(0xFFAA002F),
      ),
      home: LoginCheck(),
    );
  }
}

class LoginCheck extends StatelessWidget {
  LoginCheck({Key? key}) : super(key: key);

  final bool isLogin = SharedPrefConstant.isUserLogin ?? false;
  @override
  Widget build(BuildContext context) {
    return isLogin ? const HomePage() : const LoginScreen();
  }
}
