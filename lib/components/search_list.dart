import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/components/search_list_tile.dart';
import 'package:flutter/material.dart';

class SearchList extends StatelessWidget {
  final String? myUserName;
  final Stream? userStream;
  SearchList(this.myUserName, this.userStream);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: userStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: (snapshot.data! as QuerySnapshot).docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds =
                      (snapshot.data! as QuerySnapshot).docs[index];

                  return Column(
                    children: [
                      SearchListTile(
                        profileUrl: ds["imgUrl"],
                        name: ds["name"],
                        username: ds["username"],
                        email: ds["email"],
                        myUserName: myUserName,
                      ),
                    ],
                  );
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}
