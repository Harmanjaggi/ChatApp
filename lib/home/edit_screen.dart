import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:chat_app/helper_functions/sharedpref_helper.dart';
import 'package:chat_app/service/database.dart';

class EditScreen extends StatefulWidget {
  final String username;
  final String title, body;
  EditScreen(this.username, this.title, this.body);

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();
  Stream? editStream;
  String newBody = '';
  String? userId;

  Widget? textFieldGenerator() {
    switch (widget.title) {
      case 'Name':
        return TextFormField(
            keyboardType: TextInputType.name,
            autofocus: true,
            decoration: InputDecoration(
              hintText: widget.body,
            ),
            validator: (val) => val!.isEmpty || val.length < 3
                ? 'Enter Username 3+ characters'
                : null,
            onChanged: (val) {
              setState(() => newBody = val);
            });

      case 'About':
        return TextFormField(
            keyboardType: TextInputType.text,
            autofocus: true,
            initialValue: newBody,
            autocorrect: true,
            minLines: 1,
            maxLines: null,
            validator: (val) => val!.isEmpty ? 'Enter About yourself' : null,
            onChanged: (val) {
              setState(() => newBody = val);
            });

      case 'Email':
        return TextFormField(
          keyboardType: TextInputType.emailAddress,
          autofocus: true,
          decoration: InputDecoration(
            hintText: widget.body,
          ),
          validator: (val) {
            return RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(val!)
                ? null
                : "Enter correct email";
          },
          onChanged: (val) {
            setState(() => newBody = val);
          },
        );

      case 'Mobile Number':
        return TextFormField(
          keyboardType: TextInputType.phone,
          autofocus: true,
          decoration: InputDecoration(
            hintText: widget.body,
          ),
          validator: (val) =>
              val!.length == 9 ? 'Enter Correct Mobile Number' : null,
          onChanged: (val) {
            setState(() => newBody = val);
          },
        );
    }
  }

  Future<String?> getUserId() async {
    String? theUserId = await SharedPreferenceHelper().getUserId();
    return theUserId;
  }

  updateSharedPreference(String title, String body) async {
    switch (title) {
      case 'Name':
        await SharedPreferenceHelper().updateDisplayName(body);
        setState(() {});
        break;
      case 'About':
        await SharedPreferenceHelper().updateUserAbout(body);
        setState(() {});
        break;
      case 'Email':
        await SharedPreferenceHelper().updateUserEmail(body);
        setState(() {});
        break;
      case 'Mobile Number':
        await SharedPreferenceHelper().updateUserPhoneNumber(body);
        setState(() {});
        break;
    }
  }

  getPEditStream() async {
    userId = await getUserId();
    editStream = await DatabaseService().getUserByUserName(widget.username);
    setState(() {});
    print('userId : $userId');
  }

  @override
  void initState() {
    // TODO: implement initState
    getPEditStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: editStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: (snapshot.data! as QuerySnapshot).docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    // DocumentSnapshot ds =
                    //     (snapshot.data! as QuerySnapshot).docs[index];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20.0,
                        ),
                        Text('Edit your ${widget.title}'),
                        Form(
                          key: _formKey,
                          child: textFieldGenerator() ?? Text('error'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red, // background
                                onPrimary: Colors.white, // foreground
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  switch (widget.title) {
                                    case 'Name':
                                      {
                                        await DatabaseService()
                                            .updateProfile(userId!, {
                                          'name': newBody,
                                        });
                                        updateSharedPreference(
                                            widget.title, newBody);
                                      }
                                      break;

                                    case 'About':
                                      DatabaseService().updateProfile(userId!, {
                                        'about': newBody,
                                      });
                                      updateSharedPreference(
                                          widget.title, newBody);

                                      break;

                                    case 'Mobile Number':
                                      (snapshot.data! as QuerySnapshot)
                                          .docs[index]
                                          .reference
                                          .update({
                                        'phoneNumber': newBody,
                                      });
                                      updateSharedPreference(
                                          widget.title, newBody);

                                      break;
                                  }

                                  Navigator.pop(context);
                                }
                              },
                              child: Text('Save'),
                            )
                          ],
                        ),
                      ],
                    );
                  })
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}
