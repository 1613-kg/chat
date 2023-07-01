import 'package:chat/providers/LoginData.dart';
import 'package:chat/providers/database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/chatScreen.dart';

class grouppListSearch extends StatefulWidget {
  QuerySnapshot? searchSnapshot;
  grouppListSearch({super.key, required this.searchSnapshot});

  @override
  State<grouppListSearch> createState() => _grouppListSearchState();
}

class _grouppListSearchState extends State<grouppListSearch> {
  String userName = "";
  bool isJoined = false;

  getCurrentUserIdandName() async {
    await LoginData.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
  }

  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  joinedOrNot(
      String userName, String groupId, String groupname, String admin) async {
    await DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
        .isUserJoined(groupname, groupId, userName)
        .then((value) {
      setState(() {
        isJoined = value!;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getCurrentUserIdandName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.searchSnapshot!.docs.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final data = widget.searchSnapshot!.docs[index];
          joinedOrNot(
              userName, data['groupId'], data['groupName'], data['admin']);

          return ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                data['groupName'].substring(0, 1).toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(data['groupName'],
                style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text("Admin: ${getName(data['admin'])}"),
            trailing: TextButton(
              onPressed: () async {
                await DatabaseServices(
                        uid: FirebaseAuth.instance.currentUser!.uid)
                    .toggleGroupJoin(
                        data['groupId'], userName, data['groupName'])
                    .then((value) {
                  if (isJoined) {
                    setState(() {
                      isJoined = !isJoined;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Successfully joined the group ${data['groupName']}"),
                      backgroundColor: Colors.green,
                    ));
                    Future.delayed(Duration(seconds: 2), () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => charScreen(
                                    groupId: data['groupId'],
                                    groupName: data['groupName'],
                                    userName: userName,
                                  )));
                    });
                  } else {
                    setState(() {
                      isJoined = !isJoined;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Left the group ${data['groupName']}"),
                        backgroundColor: Colors.red,
                      ));
                    });
                  }
                });
              },
              child: (isJoined)
                  ? Text(
                      "Leave",
                      style: TextStyle(color: Colors.red),
                    )
                  : Text(
                      "Join",
                      style: TextStyle(color: Colors.green),
                    ),
            ),
          );
        });
  }
}
