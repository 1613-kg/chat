import 'package:chat/providers/database_services.dart';
import 'package:chat/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/membersWidget.dart';

class groupInfo extends StatefulWidget {
  String groupId;
  String groupName;
  String adminName;
  groupInfo(
      {super.key,
      required this.adminName,
      required this.groupId,
      required this.groupName});

  @override
  State<groupInfo> createState() => _groupInfoState();
}

class _groupInfoState extends State<groupInfo> {
  Stream? members;
  getGroupMembers() async {
    await DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMemebers(widget.groupId)
        .then((val) {
      setState(() {
        members = val;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getGroupMembers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        toolbarHeight: 70,
        title: Text("Group Information"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.exit_to_app)),
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                child: Icon(
                  Icons.group,
                  size: 60,
                ),
                radius: 80,
              ),
              SizedBox(
                height: 10,
              ),
              Text(widget.groupName.toUpperCase()),
              SizedBox(
                height: 20,
              ),
              Divider(
                thickness: 3,
                height: 10,
                endIndent: 20,
                indent: 20,
              ),
              membersList(),
            ]),
      ),
    );
  }

  membersList() {
    return StreamBuilder(
        stream: members,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['members'] != null) {
              if (snapshot.data['members'].length > 0) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data['members'].length,
                    itemBuilder: (context, index) {
                      return membersWidget(
                          memberName: snapshot.data['members'][index]);
                    });
              } else {
                return Center(
                  child: Text("No Members"),
                );
              }
            } else {
              return Center(
                child: Text("No Members"),
              );
            }
          } else
            return loading();
        });
  }
}
