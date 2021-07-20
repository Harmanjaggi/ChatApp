import 'package:chat_app/utilities/circle_box_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/service/database.dart';
import '../home/chat_screen.dart';

class SearchListTile extends StatelessWidget {
  final String? myUserName;
  final String profileUrl;
  final name, username, email;
  SearchListTile(
      {required this.profileUrl,
      this.name,
      this.username,
      this.email,
      this.myUserName});

  getChatRoomIdByUsernames(String a, String b) {
    // if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0))
    if (a.length > b.length) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (myUserName != null) {
          var chatRoomId = getChatRoomIdByUsernames(myUserName!, username);
          Map<String, dynamic> chatRoomInfoMap = {
            "users": [myUserName, username]
          };

          // For firebase
          DatabaseService().createChatRoom(chatRoomId, chatRoomInfoMap);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatScreen(username, name)),
          );
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 10,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Card(
          elevation: 5.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          child: Container(
            width: MediaQuery.of(context).size.width - 10,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                CircleBoxImage(profileUrl, 40),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(email),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
