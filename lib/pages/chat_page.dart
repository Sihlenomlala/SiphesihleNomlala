import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:realtimesmss/components/chat_bubble.dart';
import 'package:realtimesmss/components/my_text_field.dart';
import 'package:realtimesmss/service/chat/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserID;
  const ChatPage({
    super.key,
  required this.receiverUserEmail,
  required this.receiverUserID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    // only send message if there is something to send
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserID, _messageController.text);
      // clear the text controller after sending the message
      _messageController.clear();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiverUserEmail),),
      body: Column(
        children: [
          // message
          Expanded(
              child: _buildMessageList(),
          ),

          // user input
          _buildMessageInput(),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
  // build message list
  Widget _buildMessageList() {
    return StreamBuilder(
        stream: _chatService.getMessages(
            widget.receiverUserID, _firebaseAuth.currentUser!.uid),
        builder: (context, snapshort){
          if (snapshort.hasError) {
            return Text('Error${snapshort.error}');

          }

          if (snapshort.connectionState == ConnectionState.waiting) {
            return const Text('Loading...');

          }
          return ListView(
            children:
            snapshort.data!.docs
                .map((document) => _buildMessageItem(document))
                .toList(),
          );
        },
        );
  }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // align the message if the sender is the current user, otherwise to the left
    var alignment = (data['sender id'] == _firebaseAuth.currentUser!.uid)
    ? Alignment.centerRight:
        Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
          padding: const EdgeInsets.all(8.0),
        child:   Column(
          crossAxisAlignment:
          (data['senderId'] == _firebaseAuth.currentUser!.uid)
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
        mainAxisAlignment:
        (data['senderId'] == _firebaseAuth.currentUser!.uid)
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Text(data['senderEmail']),
          const SizedBox(height: 5),
          ChatBubble(message: data['message']),
        ],
      ),
    ),
    );
  }

  // build message input
  Widget _buildMessageInput() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
      children: [
        // textField
        Expanded(
            child: MyTextField(
                controller: _messageController,
                hintText: 'Enter message',
                obscureText: false,
            ),
        ),


        //send button
        IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.arrow_upward,
              size: 40,
            )
        ),
      ],
      ),
    );
  }
}
