import 'package:chat_app/helper_functions/sharedpref_helper.dart';
import 'package:chat_app/service/database.dart';
import 'package:chat_app/utilities/circle_box_image.dart';
import 'package:chat_app/utilities/profile_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/utilities/constant.dart';
import 'package:random_string/random_string.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  final String chatWithUsername, name;
  ChatScreen(this.chatWithUsername, this.name);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? chatWithImage,
      chatWithName,
      chatWithEmail,
      chatWithUserName,
      chatWithMobile,
      chatWithAbout;
  String messageId = '';
  String? chatRoomId, myName, myProfilePic, myUserName, myEmail;
  Stream? messageStream;
  bool chatWithProfile = false;
  TextEditingController messageTextEditingController = TextEditingController();

  getMyInfoFromSharedPreference() async {
    myName = await SharedPreferenceHelper().getUserName();
    myProfilePic = await SharedPreferenceHelper().getUserProfileUrl();
    myUserName = await SharedPreferenceHelper().getUserName();
    myEmail = await SharedPreferenceHelper().getUserEmail();

    chatRoomId = getChatRoomIdByUsernames(widget.chatWithUsername, myUserName!);
  }

  getChatRoomIdByUsernames(String a, String b) {
    // if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0))
    if (a.length > b.length) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  getImageOfChatWith() async {
    QuerySnapshot chatWithData =
        await DatabaseService().getUserInfo(widget.chatWithUsername);
    setState(() {
      chatWithImage = chatWithData.docs[0]["imgUrl"];
      chatWithName = chatWithData.docs[0]["name"];
      chatWithEmail = chatWithData.docs[0]["email"];
      chatWithUserName = chatWithData.docs[0]["username"];
      chatWithMobile = chatWithData.docs[0]["phoneNumber"];
      chatWithAbout = chatWithData.docs[0]["about"];
    });
  }

  addMessage(bool sendClicked) {
    if (sendClicked == true) {
      if (messageTextEditingController.text != "") {
        String message = messageTextEditingController.text;

        DateTime lastMessageTs = DateTime.now(); //todo 1st change date

        Map<String, dynamic> messageInfoMap = {
          "message": message,
          "sendBy": myUserName,
          "ts": lastMessageTs,
          "imgUrl": myProfilePic
        };
        // messsageId
        if (messageId == "") {
          messageId = randomAlphaNumeric(12);
        }

        DatabaseService()
            .addMessage(chatRoomId!, messageId, messageInfoMap)
            .then((value) {
          Map<String, dynamic> lastMessageInfoMap = {
            "lastMessage": message,
            "lastMessageSendTs": lastMessageTs,
            "lastMessageSendBy": myUserName
          };

          DatabaseService()
              .updateLastMessageSend(chatRoomId!, lastMessageInfoMap);
          if (sendClicked) {
            // remove the text in the message input field
            messageTextEditingController.text = "";
            // make message id blank to get regenerated on next message send
            messageId = "";
          }
        });
      }
    }
  }

  Widget chatMessageTile(String message, bool sendByMe, Timestamp time) {
    return Column(
      crossAxisAlignment:
          sendByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(
                maxHeight: 5000,
                minHeight: 50,
                minWidth: 100,
                maxWidth: 250,
              ),
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                  bottomLeft:
                      sendByMe ? Radius.circular(24) : Radius.circular(0),
                  bottomRight:
                      sendByMe ? Radius.circular(0) : Radius.circular(24),
                ),
                color: sendByMe ? Colors.purple : Color(0xfff1f0f0),
              ),
              padding: EdgeInsets.all(16),
              child: Flexible(
                child: Text(
                  message,
                  style: TextStyle(
                    color: sendByMe ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),

            // Container(
            //   height: 10.0,
            //   width: 10.0,
            // ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
          child: Text(
            '${DateFormat.jm().format(time.toDate())}',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget chatMessages() {
    return Scaffold(
      body: StreamBuilder(
          stream: messageStream,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    padding: EdgeInsets.only(bottom: 70, top: 16),
                    itemCount: (snapshot.data! as QuerySnapshot).docs.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      DocumentSnapshot ds =
                          (snapshot.data! as QuerySnapshot).docs[index];
                      return chatMessageTile(
                          ds["message"], myUserName == ds["sendBy"], ds["ts"]);
                    })
                : Center(
                    child: CircularProgressIndicator(),
                  );
          }),
    );
  }

  getAndSetMessages() async {
    messageStream = await DatabaseService().getChatRoomMessages(chatRoomId);
    setState(() {});
  }

  doThisOnLaunch() async {
    await getMyInfoFromSharedPreference();
    getAndSetMessages();
  }

  assignProfilePic() async {
    await getImageOfChatWith();
  }

  @override
  void initState() {
    // TODO: implement initState

    doThisOnLaunch();
    assignProfilePic();
    super.initState();
  }

  @override //todo start
  Widget build(BuildContext context) {
    print("chat screen working");
    return chatWithProfile
        ? Scaffold(
            appBar: AppBar(
              title: Text('Profile'),
              leading: IconButton(
                onPressed: () {
                  setState(() {
                    chatWithProfile = false;
                  });
                },
                icon: Icon(Icons.arrow_back),
              ),
            ),
            body: SingleChildScrollView(
              reverse: true,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(70.0),
                    child: Center(
                      child: CircleBoxImage(chatWithImage, 80),
                    ),
                  ),
                  Row(
                    children: [
                      ProfileText(
                        icon: Icon(Icons.account_box_rounded),
                        title: 'Name',
                        body: chatWithName ?? '',
                      ),
                    ],
                  ),
                  const Divider(
                    height: 20,
                    thickness: 1,
                    indent: 30,
                    endIndent: 30,
                  ),
                  ProfileText(
                    icon: Icon(Icons.email_rounded),
                    title: 'Username',
                    body: chatWithUserName ?? '',
                  ),
                  const Divider(
                    height: 20,
                    thickness: 1,
                    indent: 30,
                    endIndent: 30,
                  ),
                  ProfileText(
                    icon: Icon(Icons.email_rounded),
                    title: 'Email',
                    body: chatWithEmail ?? '',
                  ),
                  const Divider(
                    height: 20,
                    thickness: 1,
                    indent: 30,
                    endIndent: 30,
                  ),
                  Row(
                    children: [
                      ProfileText(
                        icon: Icon(Icons.phone_android),
                        title: 'About',
                        body: chatWithAbout ?? '',
                      ),
                    ],
                  ),
                  const Divider(
                    height: 20,
                    thickness: 1,
                    indent: 30,
                    endIndent: 30,
                  ),
                  Row(
                    children: [
                      ProfileText(
                        icon: Icon(Icons.account_box_rounded),
                        title: 'Mobile Number',
                        body: chatWithMobile ?? '',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        : SafeArea(
            child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(110),
              child: Container(
                color: Theme.of(context).primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            chatWithProfile = true;
                          });
                        },
                        child: Row(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: CircleBoxImage(chatWithImage, 20),
                            ),
                            Text(
                              widget.name,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            body: Container(
              child: Stack(
                children: [
                  chatMessages(),
                  Container(
                    alignment: AlignmentDirectional.bottomCenter,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: TextFormField(
                      autofocus: true,
                      autocorrect: chatWithProfile ? true : false,
                      minLines: 1,
                      maxLines: null,
                      controller: messageTextEditingController,
                      onChanged: (value) {
                        addMessage(false);
                      },
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'type a message',
                        suffixIcon: GestureDetector(
                          child: Icon(Icons.send),
                          onTap: () {
                            addMessage(true);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ));
  }
}
