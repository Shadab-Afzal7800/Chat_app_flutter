import 'package:chat_app_flutter/models/user_model.dart';
import 'package:chat_app_flutter/pages/chatroom_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const SearchPage({
    Key? key,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Start a new chat"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Search by email",
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            CupertinoButton(
              child: Text("Search"),
              onPressed: () {
                if (searchController.text.isNotEmpty) {
                  setState(() {});
                }
              },
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .where("email", isEqualTo: searchController.text)
                  .where("email", isNotEqualTo: widget.userModel.email)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;

                    if (dataSnapshot.docs.length > 0) {
                      Map<String, dynamic> userMap =
                          dataSnapshot.docs[0].data() as Map<String, dynamic>;

                      UserModel searchedUser = UserModel.fromMap(userMap);
                      return ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ChatRoom();
                          }));
                        },
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(searchedUser.profilepic!),
                          backgroundColor: Colors.grey[500],
                        ),
                        title: Text(searchedUser.fullname!),
                        subtitle: Text(searchedUser.email!),
                      );
                    } else {
                      return Text("No results found");
                    }
                  } else if (snapshot.hasError) {
                    return Text("An error occurred");
                  } else {
                    return Text("No results found");
                  }
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
