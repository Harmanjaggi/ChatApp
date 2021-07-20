import 'package:chat_app/home/home.dart';
import 'package:chat_app/service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/model/user_function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:chat_app/helper_functions/sharedpref_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //create user obj based on FirebaseUser
  UserFunction? _userFromFirebaseUser(User? user) {
    return ((user != null) ? UserFunction(uid: user.uid) : null);
  }

  getCurrentUser() async {
    return await _auth.currentUser;
  }
  //create user obj based on FirebaseUser

  Stream<UserFunction?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // //sign in anon
  // Future signInAnon() async {
  //   try {
  //     UserCredential result = await _auth.signInAnonymously();
  //     User? user = result.user;
  //     //developer.log("this is our user" + result.user.toString());
  //
  //     return _userFromFirebaseUser(user);
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  //sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      QuerySnapshot querySnapshot =
          await DatabaseService().getUserInfoByEmail(email);
      if (result != null) {
        SharedPreferenceHelper().saveUserEmail(email);
        SharedPreferenceHelper().saveUserId(querySnapshot.docs[0].id);
        SharedPreferenceHelper()
            .saveUserName("${querySnapshot.docs[0]["username"]}");
        SharedPreferenceHelper()
            .saveUserPhoneNumber("${querySnapshot.docs[0]["phoneNumber"]}");
        SharedPreferenceHelper()
            .saveDisplayName("${querySnapshot.docs[0]["name"]}");
        SharedPreferenceHelper()
            .saveUserProfileUrl("${querySnapshot.docs[0]["imgUrl"]}");
        return _userFromFirebaseUser(user);
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email & password
  // Future<String> getUserName(String username) async {
  //   String newUsername;
  //   QuerySnapshot checkUsername = await DatabaseService().getUserInfo(username);
  //   if (checkUsername != null) {
  //     newUsername = "$username${randomAlphaNumeric(4)}";
  //     return newUsername;
  //   }
  //   return username;
  // }

  Future registerWithEmailAndPassword(
      String email, String password, String name, String phoneNumber) async {
    // try {
    String userName;

    print(phoneNumber);
    print(name);
    UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    User? userDetails = result.user;
    userName =
        ((userDetails!.email!.replaceAll("@", "")).replaceAll(".com", ""))
            .replaceAll("gmail", "");
    // if(DatabaseService().getUserByUserName(userName).)
    // userDetails!.updateDisplayName(name);
    if (result != null) {
      SharedPreferenceHelper().saveUserEmail(userDetails.email!);
      SharedPreferenceHelper().saveUserId(userDetails.uid);
      SharedPreferenceHelper().saveUserName(userName);
      SharedPreferenceHelper().saveUserPhoneNumber(phoneNumber);
      SharedPreferenceHelper().saveDisplayName(name);
      SharedPreferenceHelper().saveUserProfileUrl('');

      Map<String, dynamic> userInfoMap = {
        'username': userName,
        'name': name,
        'email': userDetails.email,
        'phoneNumber': phoneNumber,
        'imgUrl': '',
        'about': '',
      };

      DatabaseService().addUserInfoToDB(userDetails.uid, userInfoMap);
      //     .then((value) {
      //   Navigator.pushReplacement(
      //       context, MaterialPageRoute(builder: (context) => Home()));
      // });

      return _userFromFirebaseUser(userDetails);
    }
    // } catch (e) {
    //   print(e.toString());
    //   return null;
    // }
  }

  //reset password
  Future passwordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return 'user';
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Sign in with google
  Future signInWithGoogle(BuildContext context) async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    UserCredential result = await _auth.signInWithCredential(credential);

    User? userDetails = result.user;
    if (result != null) {
      SharedPreferenceHelper().saveUserEmail(userDetails!.email!);
      SharedPreferenceHelper().saveUserId(userDetails.uid);
      SharedPreferenceHelper()
          .saveUserName(userDetails.email!.replaceAll("@gmail.com", ""));
      SharedPreferenceHelper().saveDisplayName(userDetails.displayName!);
      SharedPreferenceHelper().saveUserProfileUrl(userDetails.photoURL!);

      Map<String, dynamic> userInfoMap = {
        'username': userDetails.email!.replaceAll('@gmail.com', ''),
        'name': userDetails.displayName,
        'email': userDetails.email,
        'phoneNumber': userDetails.phoneNumber ?? '',
        'about': '',
        'imgUrl': userDetails.photoURL,
      };

      DatabaseService()
          .addUserInfoToDB(userDetails.uid, userInfoMap)
          .then((value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      });

      return _userFromFirebaseUser(userDetails);
    }
  }

  //sign out
  Future signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await _auth.signOut();
    return _userFromFirebaseUser(null);
  }
}
