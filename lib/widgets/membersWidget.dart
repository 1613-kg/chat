import 'package:flutter/material.dart';

class membersWidget extends StatelessWidget {
  String memberName;
  membersWidget({super.key, required this.memberName});
  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            getName(memberName).substring(0, 1).toUpperCase(),
            style: const TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(getName(memberName)),
        subtitle: Text(getId(memberName)),
      ),
    );
  }
}
