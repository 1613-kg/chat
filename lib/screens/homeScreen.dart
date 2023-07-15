import 'package:chat/providers/LoginData.dart';
import 'package:chat/providers/auth_services.dart';
import 'package:chat/providers/database_services.dart';
import 'package:chat/screens/searchScreen.dart';
import 'package:chat/widgets/groupsDisplay.dart';
import 'package:chat/widgets/loading.dart';
import 'package:chat/widgets/noGroup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/customDrawer.dart';

class homeScreen extends StatefulWidget {
  homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  String email = "";
  String userName = "";
  String profilePic = "";
  AuthService _authService = AuthService();
  Stream? groups;
  String groupName = "";
  bool isLoading = false;

  getUserData() async {
    await LoginData.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await LoginData.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });

    await DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshots) {
      setState(() {
        groups = snapshots;
      });
    });

    QuerySnapshot snapshot =
        await DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
            .gettingUserData(email);

    setState(() {
      profilePic = snapshot.docs[0]['profilePic'];
      isLoading = false;
    });
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          "Groupie",
          textAlign: TextAlign.center,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (contex) => searchScreen()));
              },
              icon: Icon(Icons.search)),
        ],
        centerTitle: true,
      ),
      drawer: customDrawer(
        userName: userName,
        email: email,
        profilePic: profilePic,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          addGroupPopUp(context);
        },
      ),
      body: (isLoading)
          ? loading()
          : StreamBuilder(
              stream: groups,
              builder: ((context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data['groups'] != null) {
                    if (snapshot.data['groups'].length != 0) {
                      return ListView.builder(
                          itemCount: snapshot.data['groups'].length,
                          itemBuilder: (context, index) {
                            int reverseIndex =
                                snapshot.data['groups'].length - index - 1;
                            return groupsDisplay(
                              groupId:
                                  getId(snapshot.data['groups'][reverseIndex]),
                              groupName: getName(
                                  snapshot.data['groups'][reverseIndex]),
                              userName: snapshot.data['fullName'],
                              email: email,
                            );
                          });
                    } else
                      return noGroup();
                  } else
                    return noGroup();
                } else
                  return loading();
              }),
            ),
    );
  }

  addGroupPopUp(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Create a group"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                (isLoading)
                    ? loading()
                    : TextField(
                        onChanged: (val) {
                          setState(() {
                            groupName = val;
                          });
                        },
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(20)),
                            errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(20)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(20))),
                      )
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel")),
              TextButton(
                  onPressed: () async {
                    if (groupName != '') {
                      setState(() {
                        isLoading = true;
                      });
                      DatabaseServices(
                              uid: FirebaseAuth.instance.currentUser!.uid)
                          .createGroup(userName,
                              FirebaseAuth.instance.currentUser!.uid, groupName)
                          .whenComplete(() {
                        isLoading = false;
                      });
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Group created succesfully"),
                        backgroundColor: Colors.orange,
                        duration: const Duration(seconds: 2),
                        action: SnackBarAction(
                          label: "OK",
                          onPressed: () {},
                          textColor: Colors.white,
                        ),
                      ));
                    }
                  },
                  child: Text("Create")),
            ],
          );
        });
  }
}
