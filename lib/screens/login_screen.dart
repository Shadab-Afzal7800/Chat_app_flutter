import 'package:chat_app_flutter/services/firebase_services/login_services.dart';
import 'package:chat_app_flutter/widgets/custom_alert_dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:chat_app_flutter/constants/colors.dart';
import 'package:chat_app_flutter/screens/create_account.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  LoginServices loginServices = LoginServices();

  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      CustomDialog.showAlertDialog(context, '', "Please fill all the fields");
    } else {
      loginServices.login(context, email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'Chat App',
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 44,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                const SizedBox(height: 30),
                CupertinoButton(
                  onPressed: () {
                    checkValues();
                  },
                  color: kPrimaryColor,
                  child: const Text('Login'),
                )
              ],
            ),
          ),
        ),
      )),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Don't have an account?"),
          CupertinoButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateAccountPage()));
              },
              child: const Text(
                'Sign Up',
                style: TextStyle(color: kPrimaryColor),
              ))
        ],
      ),
    );
  }
}
