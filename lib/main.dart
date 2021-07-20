import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/service/auth.dart';
import 'package:chat_app/model/user_function.dart';
import 'package:chat_app/authenticate/reset_screen.dart';
import 'package:chat_app/home/profile_screen.dart';
import 'package:chat_app/wrapper.dart';
import 'authenticate/welcome_screen.dart';
import 'authenticate/login_screen.dart';
import 'authenticate/registration_screen.dart';
import 'home/chat_screen.dart';
import 'package:chat_app/home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String title = 'Set up Firebase & Flutter';

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserFunction?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        // return MaterialApp(
        // home: MainPage(
        //   title: title,
        // ),
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData(
          primarySwatch: Colors.purple,
          primaryColor: Color(0xFF330066),
          applyElevationOverlayColor: true,
          // appBarTheme: AppBarTheme(
          //   backgroundColor: colorScheme.brightness == Brightness.dark
          //       ? Colors.grey[900]
          //       : Colors.white,
          // ),
          brightness: Brightness.dark,
          accentColor: Colors.white,
          accentIconTheme: IconThemeData(color: Colors.black),
        ),

        home: FutureBuilder(
          future: AuthService().getCurrentUser(),
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              print('home');
              return Home();
            } else {
              print('Welcome');
              return WelcomeScreen();
            }
          },
        ),

        initialRoute: Wrapper.id,
        routes: {
          Wrapper.id: (context) => Wrapper(),
          ResetScreen.id: (context) => ResetScreen(),
          WelcomeScreen.id: (context) => WelcomeScreen(),
          Home.id: (context) => Home(),
          ProfileScreen.id: (context) => ProfileScreen(),
        },
      ),
    );
  }
}
