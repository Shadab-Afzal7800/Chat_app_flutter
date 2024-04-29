import 'package:chat_app_flutter/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  void showPhotoOptions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Upload Profile Picture'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.photo_album),
                  title: Text('Upload from gallery'),
                ),
                ListTile(
                  leading: Icon(Icons.camera),
                  title: Text('Take Picture'),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Complete Profile"),
      ),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            CupertinoButton(
              onPressed: () {
                showPhotoOptions();
              },
              child: CircleAvatar(
                radius: 60,
                child: Icon(
                  Icons.person,
                  size: 70,
                ),
              ),
            ),
            TextField(
              decoration: InputDecoration(label: Text('Full Name')),
            ),
            SizedBox(
              height: 20,
            ),
            CupertinoButton(
              child: Text('Done'),
              onPressed: () {},
              color: kPrimaryColor,
            )
          ],
        ),
      )),
    );
  }
}
