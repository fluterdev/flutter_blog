import 'package:blog_app/constants/constants.dart';
import 'package:blog_app/screens/auth_screens/register_screen.dart';
import 'package:blog_app/screens/home_page.dart';
import 'package:flutter/material.dart';

import '../../services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool isLoggingIn = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoggingIn
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Form(
                    key: _loginFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Center(
                          child: FlutterLogo(
                            size: 160,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Log In',
                          style: TextStyle(fontSize: 40),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Login with email',
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 80),
                        TextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value != null) {
                              if (value.isEmpty) {
                                return 'email cannot be empty';
                              } else if (!value.contains('@')) {
                                return 'invalid email';
                              }
                            }
                          },
                          decoration: const InputDecoration(
                            hintText: 'email',
                            prefixIcon: Icon(
                              Icons.email,
                              size: 18,
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          validator: (value) {
                            if (value != null) {
                              return value.length < 6 ? 'password cannot be less than 6' : null;
                            }
                          },
                          decoration: const InputDecoration(
                            hintText: 'password',
                            prefixIcon: Icon(
                              Icons.vpn_key,
                              size: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 60),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(45),
                            primary: Colors.blue,
                          ),
                          onPressed: () async {
                            if (_loginFormKey.currentState!.validate()) {
                              setState(() {
                                isLoggingIn = true;
                              });
                              final bool isSuccess = await FirebaseServices().loginWithEmail(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );

                              if (isSuccess) {
                                //setting shared pref bool value as true
                                if (SharedPrefConstant.sharedPreferences != null) {
                                  SharedPrefConstant.sharedPreferences?.setBool(isLoginKey, true);
                                }

                                //navigating to homepage if login success
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const HomePage(),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                              }

                              //showing snackbar
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(isSuccess ? 'Login Success' : 'Login Failed'),
                                ),
                              );

                              //stopping loading progress
                              setState(() {
                                isLoggingIn = false;
                              });
                            }
                          },
                          child: const Text('Login'),
                        ),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Don't have account? Signup",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
