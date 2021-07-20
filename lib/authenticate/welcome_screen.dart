import 'package:chat_app/home/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/authenticate/login_screen.dart';
import 'package:chat_app/authenticate/registration_screen.dart';
import 'package:chat_app/service/auth.dart';
import 'package:chat_app/utilities/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  static const List<Tab> myTabs = <Tab>[
    Tab(
      child: Text(
        'LogIn',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    Tab(
      child: Text(
        'Register',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
  ];

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    _tabController =
        TabController(vsync: this, length: WelcomeScreen.myTabs.length);

    super.initState();
  }

  late TabController _tabController;
  bool isRegister = false;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tabController.addListener(() {
      setState(() {
        isRegister = _tabController.index == 1;
      });
      print("working ${_tabController.index}");
    });

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isRegister ? 150 : 250),
        child: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          centerTitle: true,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/chatlogo.png'),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20)),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    tabs: WelcomeScreen.myTabs,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          LoginScreen(),
          RegistrationScreen(),
        ],
      ),
    );
  }
}
