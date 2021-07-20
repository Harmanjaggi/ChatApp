import 'package:chat_app/model/user_function.dart';
import 'package:chat_app/authenticate/welcome_screen.dart';
import 'package:chat_app/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;

class Wrapper extends StatefulWidget {
  static const String id = 'wrapper';

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool? isChatScreen;

  @override
  Widget build(BuildContext context) {
    //return either Home or Authenticate widget
    try {
      UserFunction? user;
      setState(() {
        user = Provider.of<UserFunction?>(context);
      });
      //return either Home or Authenticate widget
      Navigator.popUntil(context, ModalRoute.withName(Wrapper.id));
      if (user == null) {
        print("welcome screen");
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => WelcomeScreen()),
        // );
        return WelcomeScreen();
      } else {
        print("chat screen");
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => Home()),
        // );
        return Home();
      }
    } catch (e) {
      print(e.toString());
    }
    return Home();
  }
}
