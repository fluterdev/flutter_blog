import 'package:blog_app/services.dart';
import 'package:flutter/material.dart';

import '../home_page.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool isSigningIn = false;

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
        child: isSigningIn
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Form(
                    key: _signupFormKey,
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
                          'Create\nAccount',
                          style: TextStyle(fontSize: 40),
                        ),
                        const SizedBox(height: 20),
                        const SizedBox(height: 80),
                        TextFormField(
                          controller: _usernameController,
                          validator: (value) {
                            if (value != null) {
                              return value.isEmpty ? 'username cannot be empty' : null;
                            }
                          },
                          decoration: const InputDecoration(
                            hintText: 'username',
                            prefixIcon: Icon(
                              Icons.person,
                              size: 18,
                            ),
                          ),
                        ),
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
                            if (_signupFormKey.currentState!.validate()) {
                              //setting state for showing loading based on bool value
                              setState(() {
                                isSigningIn = true;
                              });

                              //calling firebase auth service for login
                              final bool isSuccess = await FirebaseServices().registerWithEmail(
                                email: _emailController.text,
                                password: _passwordController.text,
                                username: _usernameController.text,
                              );

                              if (isSuccess) {
                                //navigating to homepage if success
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const HomePage(),
                                    ),
                                    (Route<dynamic> route) => false);
                              }

                              //showing snackbar
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(isSuccess ? 'Signup Success' : 'Signup Failed'),
                                ),
                              );

                              setState(() {
                                isSigningIn = false;
                              });
                            }
                          },
                          child: const Text('Signup'),
                        ),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Already have have account? Login",
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
