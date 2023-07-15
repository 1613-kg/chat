import 'package:chat/screens/chatScreen.dart';
import 'package:flutter/material.dart';

class groupsDisplay extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;
  final String email;
  groupsDisplay(
      {super.key,
      required this.userName,
      required this.groupId,
      required this.groupName,
      required this.email});

  @override
  State<groupsDisplay> createState() => _groupsDisplayState();
}

class _groupsDisplayState extends State<groupsDisplay> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (contex) => charScreen(
                      groupId: widget.groupId,
                      groupName: widget.groupName,
                      userName: widget.userName,
                      email: widget.email,
                    )));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              widget.groupName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          title: Text(
            widget.groupName.toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "Join the conversation as ${widget.userName}",
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  }
}
