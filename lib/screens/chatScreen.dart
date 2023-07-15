import 'package:chat/providers/database_services.dart';
import 'package:chat/screens/groupInfo.dart';
import 'package:chat/widgets/sendMessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

import '../widgets/messageTile.dart';

class charScreen extends StatefulWidget {
  String groupId;
  String groupName;
  String userName;
  String email;
  charScreen(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.userName,
      required this.email});

  @override
  State<charScreen> createState() => _charScreenState();
}

class _charScreenState extends State<charScreen> {
  Stream<QuerySnapshot>? chats;
  String admin = "";
  // TextEditingController messageController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    getChatsAndAdmin();
    super.initState();
  }

  getChatsAndAdmin() {
    DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
        .getChats(widget.groupId)
        .then((value) {
      setState(() {
        chats = value;
      });
    });

    DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupAdmin(widget.groupId)
        .then((value) {
      setState(() {
        admin = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.groupName.toUpperCase()),
          centerTitle: true,
          backgroundColor: Colors.deepOrangeAccent,
          actions: [
            IconButton(
                onPressed: () {
                  Share.share(
                      'Join our group using this link: ${widget.groupId}_${widget.groupName}');
                },
                icon: Icon(Icons.share_sharp)),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => groupInfo(
                                groupId: widget.groupId,
                                groupName: widget.groupName,
                                adminName: admin,
                                userName: widget.userName,
                              )));
                },
                icon: Icon(Icons.info)),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SingleChildScrollView(
                child: Container(
                  height: screenHeight - keyboardHeight - 180,
                  width: MediaQuery.of(context).size.width,
                  child: chatMessages(),
                ),
              ),
              SizedBox(
                height: 13,
              ),
              sendMessage(
                  userName: widget.userName,
                  email: widget.email,
                  groupId: widget.groupId),
            ],
          ),
        ),
      ),
    );
  }

  chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return messageTile(
                      message: snapshot.data.docs[index]['message'],
                      sender: snapshot.data.docs[index]['sender'],
                      sentByMe: widget.email ==
                          snapshot.data.docs[index]['senderEmail']);
                },
              )
            : Container();
      },
    );
  }
}
