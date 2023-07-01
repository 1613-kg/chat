import 'package:chat/providers/auth_services.dart';
import 'package:chat/screens/homeScreen.dart';
import 'package:chat/screens/loginScreen.dart';
import 'package:chat/widgets/loading.dart';
import 'package:flutter/material.dart';

import '../providers/LoginData.dart';
import '../widgets/input_info.dart';

class signUpScreen extends StatefulWidget {
  signUpScreen({super.key});

  @override
  State<signUpScreen> createState() => _signUpScreenState();
}

class _signUpScreenState extends State<signUpScreen> {
  final formKey = GlobalKey<FormState>();

  TextEditingController emailController = new TextEditingController();

  TextEditingController setController = new TextEditingController();

  TextEditingController confirmController = new TextEditingController();

  TextEditingController usernameController = new TextEditingController();

  AuthService authService = AuthService();
  bool _isLoading = false;
  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(
              usernameController.text, emailController.text, setController.text)
          .then((value) async {
        if (value == true) {
          // saving the shared preference state
          await LoginData.saveUserLoggedInStatus(true);
          await LoginData.saveUserEmailSF(emailController.text);
          await LoginData.saveUserNameSF(usernameController.text);
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
      backgroundColor: Colors.black12,
      body: (_isLoading)
          ? loading()
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.fromLTRB(15, 150, 15, 250),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome to Groupie",
                        style: TextStyle(color: Colors.white, fontSize: 35),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      InkWell(
                        onTap: () {},
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage: NetworkImage(
                                  "https://t3.ftcdn.net/jpg/02/09/37/00/360_F_209370065_JLXhrc5inEmGl52SyvSPeVB23hB6IjrR.jpg"),
                            ),
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
                        controller: setController,
                        myIcon: Icons.lock,
                        labelText: "Set Password",
                        toHide: true,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InputInfo(
                        controller: confirmController,
                        myIcon: Icons.lock,
                        labelText: "Confirm Password",
                        toHide: true,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InputInfo(
                        controller: usernameController,
                        myIcon: Icons.person,
                        labelText: "Username",
                        toHide: false,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            register();
                          },
                          child: Text("Sign Up")),
                      SizedBox(
                        height: 30,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => loginScreen()));
                          },
                          child: Text("Already have an account?Click Here!")),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
