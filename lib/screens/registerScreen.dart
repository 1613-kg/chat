import 'dart:io';

import 'package:chat/providers/auth_services.dart';
import 'package:chat/screens/homeScreen.dart';
import 'package:chat/screens/loginScreen.dart';
import 'package:chat/widgets/loading.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';

import '../constants.dart';
import '../providers/LoginData.dart';

class signUpScreen extends StatefulWidget {
  signUpScreen({super.key});

  @override
  State<signUpScreen> createState() => _signUpScreenState();
}

class _signUpScreenState extends State<signUpScreen> {
  final formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  String confirmPassword = "";
  String userName = "";
  String profilePic = "";

  AuthService authService = AuthService();
  bool _isLoading = false;

  File? img;
  void pickImage(ImageSource src, BuildContext context) async {
    final file = await ImagePicker().pickImage(source: src);
    File image = File(file!.path);
    File compressedImage = await customCompressed(image);

    setState(() {
      img = compressedImage;
    });
  }

  Future<File> customCompressed(File imagePath) async {
    var path = await FlutterNativeImage.compressImage(imagePath.absolute.path,
        quality: 100, percentage: 10);
    return path;
  }

  showDialogOpt(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              children: [
                SimpleDialogOption(
                  onPressed: () {
                    pickImage(ImageSource.camera, context);
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.camera),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Camera"),
                    ],
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    pickImage(ImageSource.gallery, context);
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.album),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Gallery"),
                    ],
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.close),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Close"),
                    ],
                  ),
                )
              ],
            ));
  }

  getProfilePicUrl() async {
    await authService.uploadProPic(img).then((value) {
      setState(() {
        profilePic = value;
      });
    });
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(userName, email, password, img)
          .then((value) async {
        if (value == true) {
          // saving the shared preference state
          await LoginData.saveUserLoggedInStatus(true);
          await LoginData.saveUserEmailSF(email);
          await LoginData.saveUserNameSF(userName);
          await LoginData.saveUserProfilePicSF(profilePic);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => homeScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Error in Signing In"),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: "OK",
              onPressed: () {},
              textColor: Colors.white,
            ),
          ));
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: (_isLoading)
          ? loading()
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.fromLTRB(15, 50, 15, 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Group Chatting",
                      style: TextStyle(color: Colors.black, fontSize: 30),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    InkWell(
                      onTap: () {
                        showDialogOpt(context);
                      },
                      child: Stack(
                        children: [
                          (img == null)
                              ? const CircleAvatar(
                                  radius: 60,
                                  backgroundImage: NetworkImage(
                                      "https://t3.ftcdn.net/jpg/02/09/37/00/360_F_209370065_JLXhrc5inEmGl52SyvSPeVB23hB6IjrR.jpg"),
                                )
                              : ClipOval(
                                  child: Image.file(
                                  img!,
                                  width: 150,
                                  height: 150,
                                )),
                          Positioned(
                            right: 5,
                            bottom: 5,
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(60),
                                  color: Colors.white),
                              child: Icon(
                                Icons.edit,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          // userName

                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                labelText: "UserName",
                                labelStyle: TextStyle(color: Colors.black),
                                prefixIcon: Icon(
                                  Icons.person,
                                )),
                            onChanged: (val) {
                              setState(() {
                                userName = val;
                              });
                            },
                            validator: (val) {
                              if (val!.isNotEmpty) {
                                return null;
                              } else {
                                return "Name cannot be empty";
                              }
                            },
                          ),

                          SizedBox(
                            height: 40,
                          ),

                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                labelText: "Email",
                                labelStyle: TextStyle(color: Colors.black),
                                prefixIcon: Icon(
                                  Icons.mail,
                                )),
                            onChanged: (val) {
                              setState(() {
                                email = val;
                              });
                            },
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val!)
                                  ? null
                                  : "Please enter a valid email";
                            },
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          // password

                          TextFormField(
                            obscureText: true,
                            decoration: textInputDecoration.copyWith(
                                labelText: "Password",
                                labelStyle: TextStyle(color: Colors.black),
                                prefixIcon: Icon(
                                  Icons.lock,
                                )),
                            onChanged: (val) {
                              setState(() {
                                password = val;
                              });
                            },
                            validator: (val) {
                              if (val!.length < 6) {
                                return "Password must be at least 6 characters";
                              } else {
                                return null;
                              }
                            },
                          ),

                          SizedBox(
                            height: 40,
                          ),
                          // confirmPassword

                          TextFormField(
                            obscureText: true,
                            decoration: textInputDecoration.copyWith(
                                labelText: "Confirm Password",
                                labelStyle: TextStyle(color: Colors.black),
                                prefixIcon: Icon(
                                  Icons.lock,
                                )),
                            onChanged: (val) {
                              setState(() {
                                confirmPassword = val;
                              });
                            },
                            validator: (val) {
                              if (val != password) {
                                return "Passwords do not match";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          register();
                        },
                        child: Text(
                          "Register",
                          style: TextStyle(fontSize: 25),
                        )),
                    SizedBox(
                      height: 120,
                    ),
                    Text.rich(
                      TextSpan(
                        text: "Have an existing account? ",
                        style: TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                              text: "Login now",
                              style: const TextStyle(
                                color: Colors.orange,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => loginScreen()));
                                }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
