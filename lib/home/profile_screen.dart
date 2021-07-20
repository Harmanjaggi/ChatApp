import 'package:chat_app/home/edit_screen.dart';
import 'package:chat_app/model/cloud_storage_result.dart';
import 'package:chat_app/utilities/circle_box_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/utilities/profile_text.dart';
import 'package:chat_app/helper_functions/sharedpref_helper.dart';
import 'package:chat_app/service/database.dart';
import 'package:chat_app/utilities/edit_tool.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:chat_app/utilities/loading.dart';

import 'home.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'profile_screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool pageFlip = false, loading = false;
  String? username, userId;
  Stream? profileStream;
  CloudStorageResult? image;
  File? imageFile;

  final picker = ImagePicker();

  Future pickImageByGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(pickedFile!.path);
      if (imageFile != null) {
        pageFlip = true;
      }
    });
  }

  Future pickImageByCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = File(pickedFile!.path);
      if (imageFile != null) {
        pageFlip = true;
      }
    });
  }

  getUserNameFromSharedPreference() async {
    username = await SharedPreferenceHelper().getUserName();
    userId = await SharedPreferenceHelper().getUserId();
    setState(() {});
  }

  getProfileStream() async {
    profileStream = await DatabaseService().getUserByUserName(username!);
    setState(() {});
  }

  whenInitiated() async {
    await getUserNameFromSharedPreference();
    getProfileStream();
  }

  updateImageSharedPreferenceAndDatabase(String url) async {
    await DatabaseService().updateProfile(userId!, {
      'imgUrl': url,
    });
    await SharedPreferenceHelper().updateUserProfile(url);
    setState(() {});
  }

  imageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        updateImageSharedPreferenceAndDatabase('');
                        // Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                        );
                      },
                      child: CircleAvatar(
                        radius: 20,
                        child: Icon(Icons.delete),
                      ),
                    ),
                    Text('Remove'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () {
                    pickImageByGallery();
                    Navigator.pop(context);
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        child: Icon(Icons.image_search_rounded),
                      ),
                      Text('Gallery'),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () {
                    pickImageByCamera();
                    Navigator.pop(context);
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        child: Icon(Icons.camera_alt),
                      ),
                      Text('Camera'),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<CloudStorageResult> uploadImageToFirebase(BuildContext context) async {
    String fileName = basename(imageFile!.path);
    final Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    final uploadTask = firebaseStorageRef.putFile(imageFile!);
    final taskSnapshot = await uploadTask.whenComplete(() => null);

    var downloadUrl = await taskSnapshot.ref.getDownloadURL();

    var url = downloadUrl.toString();
    return CloudStorageResult(imageUrl: url, imageFileName: fileName);
  }

  @override
  void initState() {
    // TODO: implement initState

    whenInitiated();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('1loading === $loading');
    return (pageFlip)
        ? (loading)
            ? Loading()
            : Scaffold(
                body: Stack(
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      height: 500,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(50.0),
                              bottomRight: Radius.circular(50.0)),
                          gradient: LinearGradient(
                              colors: [
                                Colors.purple.shade100,
                                Colors.purple.shade900
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight)),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      margin: const EdgeInsets.only(top: 150),
                      child: Container(
                        decoration:
                            BoxDecoration(shape: BoxShape.circle, boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            spreadRadius: 10,
                            blurRadius: 10,
                          )
                        ]),
                        child: CircleAvatar(
                          radius: 160,
                          backgroundImage: imageFile != null
                              ? Image.file(imageFile!).image
                              : AssetImage('assets/newUser.png'),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 350),
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(10.0),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                pageFlip = false;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                'Cancel',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(10.0),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              setState(() {
                                loading = true;
                              });
                              image = await uploadImageToFirebase(context);
                              updateImageSharedPreferenceAndDatabase(
                                  image!.imageUrl);
                              setState(() {
                                pageFlip = false;
                              });

                              print('3loading === $loading');
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                'Set the Image',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
        : Scaffold(
            appBar: AppBar(
              title: Text('Profile'),
              leading: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                  // Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                ),
              ),
            ),
            body: StreamBuilder(
              stream: profileStream,
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? ListView.builder(
                        itemCount:
                            (snapshot.data! as QuerySnapshot).docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot ds =
                              (snapshot.data! as QuerySnapshot).docs[index];
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(70.0),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: CircleBoxImage(ds["imgUrl"], 80),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: 130, left: 150),
                                      child: GestureDetector(
                                          child: CircleAvatar(
                                            backgroundColor:
                                                Colors.purple.shade500,
                                            child: Icon(
                                              Icons.edit_rounded,
                                              color: Colors.white,
                                            ),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              loading = false;
                                              print('2loading === $loading');
                                            });

                                            imageBottomSheet(context);
                                          }),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    )
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  ProfileText(
                                    icon: Icon(Icons.account_box_rounded),
                                    title: 'Name',
                                    body: ds["name"],
                                  ),
                                  EditTool(
                                    EditScreen(
                                      username!,
                                      'Name',
                                      ds["name"],
                                    ),
                                  )
                                ],
                              ),
                              const Divider(
                                height: 20,
                                thickness: 1,
                                indent: 30,
                                endIndent: 30,
                              ),
                              ProfileText(
                                icon: Icon(Icons.email_rounded),
                                title: 'Username',
                                body: ds["username"],
                              ),
                              const Divider(
                                height: 20,
                                thickness: 1,
                                indent: 30,
                                endIndent: 30,
                              ),
                              ProfileText(
                                icon: Icon(Icons.email_rounded),
                                title: 'Email',
                                body: ds["email"],
                              ),
                              const Divider(
                                height: 20,
                                thickness: 1,
                                indent: 30,
                                endIndent: 30,
                              ),
                              Row(
                                children: [
                                  ProfileText(
                                    icon: Icon(Icons.phone_android),
                                    title: 'About',
                                    body: ds["about"],
                                  ),
                                  EditTool(
                                    EditScreen(
                                      username!,
                                      'About',
                                      ds["about"],
                                    ),
                                  )
                                ],
                              ),
                              const Divider(
                                height: 20,
                                thickness: 1,
                                indent: 30,
                                endIndent: 30,
                              ),
                              Row(
                                children: [
                                  ProfileText(
                                      icon: Icon(Icons.account_box_rounded),
                                      title: 'Mobile Number',
                                      body: ds["phoneNumber"]),
                                  EditTool(
                                    EditScreen(
                                      username!,
                                      'Mobile Number',
                                      ds["phoneNumber"],
                                    ),
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
