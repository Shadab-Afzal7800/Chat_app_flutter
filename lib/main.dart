import 'dart:io';

import 'package:chat_app_flutter/utils/firebase_helper.dart';
import 'package:chat_app_flutter/screens/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:chat_app_flutter/models/user_model.dart';

import 'package:chat_app_flutter/screens/login_screen.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyBNW-OBoyPIFzg9Ep9hWSgSK57Z6eVi5g4",
              appId: "1:388792275228:android:921e3de3a620303c662ad9",
              messagingSenderId: '388792275228',
              projectId: "chat-app-flutter-e7a6c",
              storageBucket: "chat-app-flutter-e7a6c.appspot.com"))
      : await Firebase.initializeApp();
  User? currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser != null) {
    UserModel? thisuserModel =
        await FirebaseHelper.getUserModelById(currentUser.uid);
    if (thisuserModel != null) {
      runApp(
          MyAppLoggedIn(userModel: thisuserModel, firebaseUser: currentUser));
    } else {
      runApp(const MyApp());
    }
  } else {
    runApp(const MyApp());
  }
}

// User not logged in
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

//User already loggedIn
class MyAppLoggedIn extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  const MyAppLoggedIn(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(
        userModel: userModel,
        firebaseUser: firebaseUser,
      ),
    );
  }
}
