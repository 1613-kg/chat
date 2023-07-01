import 'package:chat/providers/LoginData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../providers/database_services.dart';
import 'loading.dart';

class noGroup extends StatefulWidget {
  const noGroup({super.key});

  @override
  State<noGroup> createState() => _noGroupState();
}

class _noGroupState extends State<noGroup> {
  bool isLoading = false;
  String groupName = "";
  String userName = "";

  getUserData() async {
    await LoginData.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              addGroupPopUp(context, userName);
            },
            child: Icon(
              Icons.add_circle,
              color: Colors.grey[700],
              size: 75,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "You've not joined any groups, tap on the add icon to create a group or also search from top search button.",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  addGroupPopUp(BuildContext context, String userName) {
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
