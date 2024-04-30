import 'package:chat_app_flutter/constants/colors.dart';
import 'package:chat_app_flutter/models/user_model.dart';
import 'package:chat_app_flutter/pages/create_account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      print('Please fill all the fields');
    } else {
      login(email, password);
    }
  }

  void login(String email, String password) async {
    UserCredential? credentials;
    try {
      credentials = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      print(ex.code.toString());
    }

    if (credentials != null) {
      String uid = credentials.user!.uid;
      DocumentSnapshot usedData =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      UserModel.fromMap(usedData.data() as Map<String, dynamic>);
      print('Login successful');
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
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Password'),
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
