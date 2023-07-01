import 'package:chat/widgets/customDrawer.dart';
import 'package:flutter/material.dart';

class profileScreen extends StatelessWidget {
  String userName;
  String email;
  profileScreen({super.key, required this.email, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
      ),
      drawer: customDrawer(userName: userName, email: email),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.network(
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQTIZccfNPnqalhrWev-Xo7uBhkor57_rKbkw&usqp=CAU",
              scale: 1.0,
            ),
            Row(
              children: [
                Text("Username: "),
                Text(userName),
              ],
            ),
            Row(
              children: [
                Text("Email: "),
                Text(email),
              ],
            )
          ],
        ),
      ),
    );
  }
}
