import 'package:flutter/material.dart';
import 'package:chat_app/utilities/constant.dart';
import 'package:chat_app/utilities/rounded_button.dart';
import 'package:chat_app/service/auth.dart';
import 'package:chat_app/utilities/loading.dart';
import 'package:chat_app/authenticate/reset_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String reset = '';
  bool enable = false;
  bool visibility = false;
  bool loading = false;
  final AuthService _auth = AuthService();

  String email = '', password = '', error = '';

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Loading();
    } else {
      return Scaffold(
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
                    ],
                  ),
                ),
                SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      child: Text(
                        'Forget Password?',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: enable ? Colors.purple : Colors.white,
                        ),
                      ),
                      onTapDown: (TapDownDetails details) {
                        setState(() {
                          enable = true;
                        });
                      },
                      onTapCancel: () {
                        setState(() {
                          enable = false;
                        });
                      },
                      onTap: () async {
                        final result =
                            await Navigator.pushNamed(context, ResetScreen.id);
                        setState(() {
                          reset = result.toString();
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                RoundedButton(
                  text: 'LogIn',
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        loading = true;
                      });
                      dynamic result = await _auth.signInWithEmailAndPassword(
                          email, password);
                      setState(() {
                        if (result == null)
                          error = 'please supply a valid email or password';
                        loading = false;
                      });
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      setState(() {
                        loading = true;
                      });
                      await _auth.signInWithGoogle(context);
                      setState(() {
                        loading = false;
                      });
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/google.png'),
                          radius: 25.0,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Log In with Google'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
