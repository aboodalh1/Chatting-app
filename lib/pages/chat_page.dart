import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/components/chat_bubble.dart';
import 'package:firebase/components/my_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../service/chat/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String recieverUserID;

  const ChatPage({super.key,
    required this.receiverUserEmail,
    required this.recieverUserID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  final ChatServices chatService = ChatServices();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await chatService.sendMessages(
          widget.recieverUserID, messageController.text); //send message

      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text(widget.receiverUserEmail),
    ),
    body:Column(
    children:[Expanded(child:buildMessageList()),
    buildMessageInput(),
    ]
    ));}

  Widget buildMessageList() {
    return StreamBuilder(stream: chatService.getMessages(
        widget.recieverUserID,
        firebaseAuth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error' + snapshot.error.toString());
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('loading...');
          }
          return ListView(
            children: snapshot.data!.docs.map((document) =>
                buildMessageItem(document)).toList(),
          );
        });
  }

  Widget buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: MyTextField(controller: messageController,
                hintText: 'Enter message', obsecureText: false),
          )),
          Container(
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(40)
            ),
            child: IconButton(onPressed: sendMessage,
                color: Colors.white,
                icon: const Icon(Icons.arrow_forward_sharp, size: 30,)),
          ),
        ],
      ),
    );
  }

  Widget buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    var alignment = (data['senderId'] == firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    return Container(

        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              crossAxisAlignment: (data['senderId'] ==
                  firebaseAuth.currentUser!.uid)
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              mainAxisAlignment: (data['senderId'] ==
                  firebaseAuth.currentUser!.uid)
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Text(data['senderEmail']),
               Padding(
                 padding: const EdgeInsets.all(12.0),
                 child: ChatBubble(message: data['message']),
               ),
              ]),
        ));
  }
}

