import 'package:chat_app/utilities/circle_box_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/service/database.dart';
import 'package:chat_app/home/chat_screen.dart';

class ChatRoomListTile extends StatefulWidget {
  final String lastMessage, chatRoomId, userName;
  ChatRoomListTile(this.lastMessage, this.chatRoomId, this.userName);

  @override
  _ChatRoomListTileState createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String name = "", username = "";
  String? profilePicUrl;

  getThisUserInfo() async {
    username =
        widget.chatRoomId.replaceAll(widget.userName, "").replaceAll("_", "");
    QuerySnapshot querySnapshot = await DatabaseService().getUserInfo(username);
    print(
        "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    print(
        "something bla bla ${querySnapshot.docs[0].id} ${querySnapshot.docs[0]["name"]}  ${querySnapshot.docs[0]["imgUrl"]}");
    name = "${querySnapshot.docs[0]["name"]}";
    profilePicUrl = "${querySnapshot.docs[0]["imgUrl"]}";
    setState(() {});
  }

  @override
  void initState() {
    getThisUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(username, name),
          ),
        );
      },
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width - 10,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Card(
            elevation: 5.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            child: Container(
              width: MediaQuery.of(context).size.width - 10,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  CircleBoxImage(profilePicUrl ?? null, 40),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 3),
                      Container(
                        width: 200,
                        height: 20,
                        child: Text(
                          widget.lastMessage,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
