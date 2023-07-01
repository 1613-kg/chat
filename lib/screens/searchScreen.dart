import 'package:chat/providers/database_services.dart';
import 'package:chat/widgets/groupListSearch.dart';
import 'package:chat/widgets/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class searchScreen extends StatefulWidget {
  const searchScreen({super.key});

  @override
  State<searchScreen> createState() => _searchScreenState();
}

class _searchScreenState extends State<searchScreen> {
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  bool hasUserSearched = false;
  QuerySnapshot? searchSnapshot;

  searchInititalize() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
          .searchByName(searchController.text)
          .then((value) {
        setState(() {
          searchSnapshot = value;
          isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.orange,
        title: Text("Search"),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              onSubmitted: (value) {
                searchInititalize();
              },
              controller: searchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                  hintText: "Search Groups...",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black, width: 2))),
            ),
            (isLoading)
                ? loading()
                : (hasUserSearched)
                    ? grouppListSearch(
                        searchSnapshot: searchSnapshot,
                      )
                    : Container(),
          ],
        ),
      ),
    );
  }
}
