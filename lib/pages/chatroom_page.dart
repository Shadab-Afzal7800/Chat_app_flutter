import 'package:chat_app_flutter/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
      ),
      body: SafeArea(
          child: Container(
        child: Column(
          children: [
            Expanded(child: Container()),
            Container(
              color: Colors.grey[200],
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Row(
                children: [
                  Flexible(
                      child: TextField(
                    decoration: InputDecoration(
                        hintText: "Enter message", border: InputBorder.none),
                  )),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.send),
                    color: kPrimaryColor,
                  )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
