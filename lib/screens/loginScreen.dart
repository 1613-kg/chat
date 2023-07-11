import 'package:chat/providers/database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../providers/LoginData.dart';
import '../providers/auth_services.dart';
import '../widgets/loading.dart';
import 'homeScreen.dart';
import 'registerScreen.dart';

class loginScreen extends StatefulWidget {
  loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";

  AuthService authService = AuthService();

  bool _isLoading = false;

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .loginWithUserNameandPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot = await DatabaseServices(
                  uid: FirebaseAuth.instance.currentUser!.uid)
              .gettingUserData(email);
          // saving the shared preference state
          await LoginData.saveUserLoggedInStatus(true);
          await LoginData.saveUserEmailSF(email);
          await LoginData.saveUserNameSF(snapshot.docs[0]['fullName']);
          await LoginData.saveUserProfilePicSF(snapshot.docs[0]['profilePic']);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => homeScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Error in Loging In"),
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
                margin: EdgeInsets.fromLTRB(15, 150, 15, 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Group Chatting",
                      style: TextStyle(color: Colors.black, fontSize: 30),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
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
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          login();
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(fontSize: 25),
                        )),
                    SizedBox(
                      height: 210,
                    ),
                    Text.rich(
                      TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                              text: "Create",
                              style: const TextStyle(
                                color: Colors.orange,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              signUpScreen()));
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
