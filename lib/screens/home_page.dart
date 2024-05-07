import 'dart:developer';

import 'package:chat_app_flutter/constants/colors.dart';
import 'package:chat_app_flutter/models/chatroom_model.dart';
import 'package:chat_app_flutter/utils/firebase_helper.dart';
import 'package:chat_app_flutter/screens/chatroom_page.dart';
import 'package:chat_app_flutter/screens/login_screen.dart';
import 'package:chat_app_flutter/screens/search_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:chat_app_flutter/models/user_model.dart';

class HomeScreen extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const HomeScreen({
    Key? key,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (ex) {
      log(ex.code.toString());
    }
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return const LoginScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat App"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                logout();
              },
              icon: const Icon(Icons.logout_outlined))
        ],
      ),
      body: SafeArea(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("chatrooms")
                  .where("users", arrayContains: widget.userModel.uid)
                  .orderBy("createdon")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    QuerySnapshot chatroomSnapshot =
                        snapshot.data as QuerySnapshot;
                    return ListView.builder(
                      itemCount: chatroomSnapshot.docs.length,
                      itemBuilder: (context, index) {
                        ChatRoomModel chatroomModel = ChatRoomModel.fromMap(
                            chatroomSnapshot.docs[index].data()
                                as Map<String, dynamic>);
                        Map<String, dynamic>? participants =
                            chatroomModel.participants;
                        List<String> participantsKeys =
                            participants!.keys.toList();
                        participantsKeys.remove(widget.userModel.uid);
                        return FutureBuilder(
                            future: FirebaseHelper.getUserModelById(
                                participantsKeys[0]),
                            builder: (context, userData) {
                              if (userData.connectionState ==
                                  ConnectionState.done) {
                                if (userData.data != null) {
                                  UserModel targetUser =
                                      userData.data as UserModel;

                                  return ListTile(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: ((context) {
                                        return ChatRoom(
                                            targetUser: targetUser,
                                            chatroom: chatroomModel,
                                            userModel: widget.userModel,
                                            firebaseUser: widget.firebaseUser);
                                      })));
                                    },
                                    title: Text(targetUser.fullname.toString()),
                                    subtitle: (chatroomModel.lastMessage
                                            .toString()
                                            .isNotEmpty)
                                        ? Text(chatroomModel.lastMessage
                                            .toString())
                                        : const Text(
                                            "Say Hi to your friend",
                                            style:
                                                TextStyle(color: kPrimaryColor),
                                          ),
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.grey[300],
                                      backgroundImage: NetworkImage(
                                          targetUser.profilepic.toString()),
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              } else {
                                return Container();
                              }
                            });
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else {
                    return const Center(
                      child: Text("No chats"),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: ((context) {
            return SearchPage(
                userModel: widget.userModel, firebaseUser: widget.firebaseUser);
          })));
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}
