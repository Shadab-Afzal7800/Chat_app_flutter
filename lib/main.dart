import 'dart:io';

import 'package:chat_app_flutter/pages/complete_profile.dart';
import 'package:chat_app_flutter/pages/create_account.dart';
import 'package:chat_app_flutter/pages/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyBNW-OBoyPIFzg9Ep9hWSgSK57Z6eVi5g4",
              appId: "1:388792275228:android:921e3de3a620303c662ad9",
              messagingSenderId: '388792275228',
              projectId: "chat-app-flutter-e7a6c"))
      : await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CompleteProfileScreen(),
    );
  }
}
