import 'package:chat_app/authenticate/welcome_screen.dart';
import 'package:chat_app/utilities/circle_box_image.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/service/auth.dart';
import 'package:chat_app/service/database.dart';
import 'package:chat_app/utilities/constant.dart';
import 'package:chat_app/home/profile_screen.dart';
import 'package:chat_app/components/search_list.dart';
import 'package:chat_app/components/chat_room_list.dart';
import 'package:chat_app/helper_functions/sharedpref_helper.dart';

class Home extends StatefulWidget {
  static const String id = 'chatroom_screen';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final AuthService _auth = AuthService();
  String messageId = '';
  String? chatRoomId, myName, myProfilePic, myUserName, myEmail;
  bool isSearching = false;
  bool searchingProcess = false;
  Stream? userStream, chatRoomStream;

  TextEditingController searchUsernameEditingController =
      TextEditingController();

  getMyInfoFromSharedPreference() async {
    myName = await SharedPreferenceHelper().getDisplayName();
    myProfilePic = await SharedPreferenceHelper().getUserProfileUrl();
    myUserName = await SharedPreferenceHelper().getUserName();
    myEmail = await SharedPreferenceHelper().getUserEmail();
    setState(() {});
  }

  onSearchBtnClick() async {
    searchingProcess = true;
    userStream = await DatabaseService()
        .getUserByUserName(searchUsernameEditingController.text);
    setState(() {});
  }

  getChatRooms() async {
    chatRoomStream = await DatabaseService().getChatRooms(myUserName);
    setState(() {});
  }

  onScreenLoaded() async {
    await getMyInfoFromSharedPreference();
    getChatRooms();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    onScreenLoaded();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatroom Screen'),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await _auth.signOut();
            },
            icon: Icon(
              Icons.exit_to_app,
            ),
          ),
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
              icon: CircleBoxImage(myProfilePic ?? null, 16))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(12.0),
                child: !isSearching
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              setState(() {
                                isSearching = true;
                              });
                            },
                            icon: Icon(Icons.search),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              isSearching = false;
                              searchingProcess = false;
                              searchUsernameEditingController.text = '';
                              setState(() {});
                            },
                            icon: Icon(Icons.arrow_back),
                          ),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              controller: searchUsernameEditingController,
                              decoration: kTextFieldDecoration.copyWith(
                                hintText: 'Search',
                                suffixIcon: GestureDetector(
                                  child: Icon(Icons.search),
                                  onTap: () {
                                    if (searchUsernameEditingController.text !=
                                        '') {
                                      onSearchBtnClick();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
              searchingProcess
                  ? Column(
                      children: [
                        SearchList(myUserName, userStream),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          height: 20,
                          thickness: 1,
                          indent: 30,
                          endIndent: 30,
                        ),
                      ],
                    )
                  : Container(),
              ChatList(myUserName, chatRoomStream),
              SizedBox(
                height: 10,
              ),
              Divider(
                height: 20,
                thickness: 1,
                indent: 30,
                endIndent: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
