import 'dart:developer';

import 'package:chat_app_flutter/models/user_model.dart';
import 'package:chat_app_flutter/screens/complete_profile.dart';
import 'package:chat_app_flutter/widgets/custom_alert_dialogs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateUserServices {
  void signUp(BuildContext context, String email, String password) async {
    UserCredential? credentials;
    CustomDialog.showLoadingDialog(context, "Creating account");

    try {
      credentials = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      CustomDialog.showAlertDialog(
          context, "Error occured", ex.message.toString());
    }
    if (credentials != null) {
      String uid = credentials.user!.uid;

      UserModel newUser =
          UserModel(uid: uid, email: email, fullname: "", profilepic: "");

      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(newUser.toMap())
          .then((value) {
        log("New user created");
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return CompleteProfileScreen(
              userModel: newUser, firebaseUser: credentials!.user!);
        }));
      });
    }
  }
}
