import 'package:chat_app_flutter/models/user_model.dart';
import 'package:chat_app_flutter/screens/home_page.dart';
import 'package:chat_app_flutter/widgets/custom_alert_dialogs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginServices {
  void login(BuildContext context, String email, String password) async {
    CustomDialog.showLoadingDialog(context, "Logging in");
    UserCredential? credentials;
    try {
      credentials = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      Navigator.pop(context);
      CustomDialog.showAlertDialog(
          context, "Error occured", ex.message.toString());
    }

    if (credentials != null) {
      String uid = credentials.user!.uid;
      DocumentSnapshot usedData =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      UserModel userModel =
          UserModel.fromMap(usedData.data() as Map<String, dynamic>);
      //Login successful
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return HomeScreen(
            userModel: userModel, firebaseUser: credentials!.user!);
      }));
    }
  }
}
