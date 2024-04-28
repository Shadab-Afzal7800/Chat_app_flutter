import 'package:chat_app_flutter/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: const Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Chat App',
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 50,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                TextField(
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                SizedBox(height: 30),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Password'),
                ),
                SizedBox(height: 30),
                CupertinoButton(
                  onPressed: null,
                  color: kPrimaryColor,
                  child: Text('Login'),
                )
              ],
            ),
          ),
        ),
      )),
      bottomNavigationBar: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Don't have an account?"),
          CupertinoButton(
              onPressed: null,
              child: Text(
                'Sign Up',
                style: TextStyle(color: kPrimaryColor),
              ))
        ],
      ),
    );
  }
}
