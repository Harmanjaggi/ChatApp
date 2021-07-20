import 'package:flutter/material.dart';
import 'package:chat_app/utilities/constant.dart';
import 'package:chat_app/utilities/rounded_button.dart';
import 'package:chat_app/service/auth.dart';
import 'package:chat_app/utilities/loading.dart';
import 'package:chat_app/service/database.dart';
import 'package:chat_app/home/chat_screen.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final AuthService _auth = AuthService();
  final DatabaseService _database = DatabaseService();

  final _formKey = GlobalKey<FormState>();
  bool visibility = false;
  bool confirmVisibility = false;
  bool passwordError = true;
  bool loading = false;

  String userName = '',
      name = '',
      phoneNumber = '',
      email = '',
      password = '',
      confirmPassword = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Please fill the input given below',
                      style: kSubscript,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            keyboardType: TextInputType.name,
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Full Name',
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: (val) => val!.isEmpty || val.length < 3
                                ? 'Enter Username 3+ characters'
                                : null,
                            onChanged: (val) {
                              setState(() => name = val);
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          // TextFormField(
                          //   keyboardType: TextInputType.text,
                          //   decoration: kTextFieldDecoration.copyWith(
                          //     hintText: 'User Name',
                          //     prefixIcon: Icon(Icons.person),
                          //   ),
                          //   validator: (val) => val!.isEmpty || val.length < 3
                          //       ? 'Username is already taken. Please use any different Username'
                          //       : null,
                          //   onChanged: (val) {
                          //     setState(() => userName = val);
                          //   },
                          // ),
                          // SizedBox(
                          //   height: 20,
                          // ),
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Phone',
                              prefixIcon: Icon(Icons.phone),
                            ),
                            validator: (val) => val!.length == 9
                                ? 'Enter Correct Phone Number'
                                : null,
                            onChanged: (val) {
                              setState(() => phoneNumber = val);
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Email',
                              prefixIcon: Icon(Icons.email),
                            ),
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val!)
                                  ? null
                                  : "Enter correct email";
                            },
                            onChanged: (val) {
                              setState(() => email = val);
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Password',
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    visibility
                                        ? visibility = false
                                        : visibility = true;
                                  });
                                },
                                child: Icon(
                                  visibility
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                            validator: (val) => val!.length < 6
                                ? 'Enter an password 6+ long'
                                : null,
                            onChanged: (val) {
                              setState(() => password = val);
                            },
                            obscureText: visibility ? false : true,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Confirm Password',
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    confirmVisibility
                                        ? confirmVisibility = false
                                        : confirmVisibility = true;
                                  });
                                },
                                child: Icon(
                                  confirmVisibility
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                            validator: (val) => confirmPassword != password
                                ? 'Confirm Password is different from Password'
                                : null,
                            onChanged: (val) {
                              setState(() => confirmPassword = val);
                            },
                            obscureText: confirmVisibility ? false : true,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    RoundedButton(
                      text: 'Register',
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });
                          dynamic result =
                              await _auth.registerWithEmailAndPassword(
                                  email, password, name, phoneNumber);
                          setState(() {
                            if (result == null)
                              error = 'please supply a valid email';
                            loading = false;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
