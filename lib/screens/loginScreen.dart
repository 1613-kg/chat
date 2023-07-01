import 'package:chat/providers/database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../providers/LoginData.dart';
import '../providers/auth_services.dart';
import '../widgets/input_info.dart';
import '../widgets/loading.dart';
import 'homeScreen.dart';
import 'signupScreen.dart';

class loginScreen extends StatefulWidget {
  loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();

  TextEditingController passwordController = new TextEditingController();

  AuthService authService = AuthService();

  bool _isLoading = false;

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .loginWithUserNameandPassword(
              emailController.text, passwordController.text)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot = await DatabaseServices(
                  uid: FirebaseAuth.instance.currentUser!.uid)
              .gettingUserData(emailController.text);
          // saving the shared preference state
          await LoginData.saveUserLoggedInStatus(true);
          await LoginData.saveUserEmailSF(emailController.text);
          await LoginData.saveUserNameSF(snapshot.docs[0]['fullName']);
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
      backgroundColor: Colors.black12,
      body: (_isLoading)
          ? loading()
          : Container(
              margin: EdgeInsets.all(15),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Groupie",
                      style: TextStyle(color: Colors.white, fontSize: 35),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    InputInfo(
                      controller: emailController,
                      myIcon: Icons.email,
                      labelText: "Email",
                      toHide: false,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InputInfo(
                      controller: passwordController,
                      myIcon: Icons.lock,
                      labelText: "Password",
                      toHide: true,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          login();
                        },
                        child: Text("Login")),
                    SizedBox(
                      height: 30,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => signUpScreen()));
                        },
                        child: Text("New User?Click Here!"))
                  ],
                ),
              ),
            ),
    );
  }
}
