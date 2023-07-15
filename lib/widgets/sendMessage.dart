import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';

import '../providers/auth_services.dart';
import '../providers/database_services.dart';

class sendMessage extends StatefulWidget {
  String userName;
  String email;
  String groupId;
  sendMessage(
      {super.key,
      required this.userName,
      required this.email,
      required this.groupId});

  @override
  State<sendMessage> createState() => _sendMessageState();
}

class _sendMessageState extends State<sendMessage> {
  TextEditingController messageController = TextEditingController();
  TextEditingController emojiController = TextEditingController();
  bool showEmojiKeyboard = false;
  AuthService authService = AuthService();
  sendMessageFuntion() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
        "senderEmail": widget.email,
      };

      DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
          .sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }

  void onTapEmojiField() {
    if (!showEmojiKeyboard) {
      setState(() {
        showEmojiKeyboard = true;
      });
    }
  }

  void pickImage(ImageSource src, BuildContext context) async {
    final file = await ImagePicker().pickImage(source: src);
    File image = File(file!.path);
    File compressedImage = await customCompressed(image);
    await authService.uploadChatImage(compressedImage).then((value) {
      setState(() {
        messageController.text = value;
      });
    });
  }

  Future<File> customCompressed(File imagePath) async {
    var path = await FlutterNativeImage.compressImage(imagePath.absolute.path,
        quality: 100, percentage: 10);
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.grey),
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                pickImage(ImageSource.camera, context);
              },
              icon: Icon(
                Icons.image,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {
                pickImage(ImageSource.gallery, context);
              },
              icon: Icon(
                Icons.album,
                color: Colors.white,
              )),
          Expanded(
              child: TextFormField(
            scrollPadding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            controller: messageController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "Send a message...",
              hintStyle: TextStyle(color: Colors.white, fontSize: 16),
              // border: OutlineInputBorder(
              //     borderSide: BorderSide(width: 1),
              //     borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
          )),
          GestureDetector(
            onTap: () {
              sendMessageFuntion();
            },
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(
                  child: Icon(
                Icons.send,
                color: Colors.white,
              )),
            ),
          ),
        ],
      ),
    );
  }
}
