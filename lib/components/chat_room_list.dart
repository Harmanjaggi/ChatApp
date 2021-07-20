import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/components/chat_room_list_tile.dart';
import 'package:flutter/material.dart';

class ChatList extends StatefulWidget {
  final String? myUserName;
  final Stream? chatRoomStream;
  ChatList(this.myUserName, this.chatRoomStream);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.chatRoomStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: (snapshot.data! as QuerySnapshot).docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds =
                      (snapshot.data! as QuerySnapshot).docs[index];

                  return ChatRoomListTile(
                      ds["lastMessage"], ds.id, widget.myUserName ?? '');
                },
              )
            : Center(child: CircularProgressIndicator());
      },
    );
  }
}
