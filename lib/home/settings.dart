import 'package:chat_app/helper_functions/sharedpref_helper.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String? name, about, imgUrl;

  getUserNameFromSharedPreference() async {
    name = await SharedPreferenceHelper().getDisplayName();
    about = await SharedPreferenceHelper().getUserAbout();
    imgUrl = await SharedPreferenceHelper().getUserProfileUrl();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  child: Image.network(imgUrl!),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Column(
                  children: [
                    Text(
                      name!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(about!),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 30.0,
            ),
            Row(
              children: [
                Icon(Icons.person),
                SizedBox(
                  width: 10,
                ),
                Text('My Profile'),
              ],
            ),
            Row(
              children: [
                Icon(Icons.account_box_rounded),
                SizedBox(
                  width: 10,
                ),
                Text('Accounts'),
              ],
            ),
            Row(
              children: [
                Icon(Icons.logout),
                SizedBox(
                  width: 10,
                ),
                Text('Log Out'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
