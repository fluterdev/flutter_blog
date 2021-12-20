import 'package:blog_app/screens/auth_screens/login_screen.dart';
import 'package:blog_app/screens/upload_blog_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
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
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        UploadBlogPage.routeName: (context) => const UploadBlogPage(),
      },
    );
  }
}
