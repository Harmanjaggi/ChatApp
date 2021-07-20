import 'package:flutter/material.dart';
import 'package:chat_app/utilities/constant.dart';
import 'package:chat_app/utilities/rounded_button.dart';
import 'package:chat_app/service/auth.dart';
import 'package:chat_app/utilities/loading.dart';

class ResetScreen extends StatefulWidget {
  static const String id = 'reset_screen';

  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  final AuthService _auth = AuthService();

  String email = '', error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('Reset Password'),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(25.0),
              child: SingleChildScrollView(
                reverse: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'Reset Password',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 40,
                      ),
                    ),
                    Text(
                      'Please fill the input blow here',
                      style: kSubscript,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Email',
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: (val) =>
                                val!.isEmpty ? 'Enter an email' : null,
                            onChanged: (val) {
                              setState(() => email = val);
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    RoundedButton(
                      text: 'Reset Password',
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });
                          dynamic result = await _auth.passwordReset(email);
                          Navigator.pop(
                              context, 'Check your email to reset password');
                          setState(() {
                            if (result == null)
                              error = 'please supply a valid email';
                            loading = false;
                          });
                        }
                      },
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
