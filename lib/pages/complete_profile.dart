import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:chat_app_flutter/constants/colors.dart';
import 'package:chat_app_flutter/models/user_model.dart';

class CompleteProfileScreen extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const CompleteProfileScreen({
    Key? key,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  TextEditingController fullnameController = TextEditingController();

  File? imageFile;
  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      cropImage(pickedFile);
    }
  }

  void cropImage(XFile file) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 50);

    if (croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
      });
    }
  }

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
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.gallery);
                  },
                  leading: Icon(Icons.photo_album),
                  title: Text('Upload from gallery'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.camera);
                  },
                  leading: Icon(Icons.camera),
                  title: Text('Take Picture'),
                )
              ],
            ),
          );
        });
  }

  void checkValues() {
    String fullname = fullnameController.text.trim();
    if (fullname.isEmpty || imageFile == null) {
      print("Please fill all the fields");
    } else {
      uploadData();
    }
  }

  void uploadData() async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref("profilepictures")
        .child(widget.userModel.uid.toString())
        .putFile(imageFile!);

    TaskSnapshot snapshot = await uploadTask;

    String? imageUrl = await snapshot.ref.getDownloadURL();
    String? fullname = fullnameController.text.trim();

    widget.userModel.fullname = fullname;
    widget.userModel.profilepic = imageUrl;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel.uid)
        .set(widget.userModel.toMap())
        .then((value) {
      log('Data uploaded!');
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
                backgroundImage:
                    imageFile != null ? FileImage(imageFile!) : null,
                child: imageFile == null
                    ? Icon(
                        Icons.person,
                        size: 70,
                      )
                    : null,
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
