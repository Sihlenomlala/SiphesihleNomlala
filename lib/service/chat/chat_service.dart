import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:realtimesmss/model/message.dart';

class ChatService extends ChangeNotifier {
// get instance of auth and fireStore
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// SEND MESSAGE
Future<void> sendMessage(String receiverID, String message) async{
  // get current user info
  final String currentUserId = _firebaseAuth.currentUser!.uid;
  final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
  final Timestamp timestamp = Timestamp.now();

  // create a new message
  Message newMessage = Message(
      senderID: currentUserId,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      timestamp: timestamp,
      message: message,
  );

  // construct chat room id form current user id and receiver id (sorted to ensure uniqueness)
  List<String> ids = [currentUserId, receiverID];
  ids.sort(); // sort the ids (this ensures the chat room id is always the same for any pair of people)
  String chatRoomId = ids.join(
 "_" ); // combine the ids into a a single string to use as a chatRoomID.

  // add new message to database
  await _firestore
  .collection('chat_rooms')
  .doc(chatRoomId)
  .collection('message')
  .add(newMessage.toMap());
}
// SEND MESSAGE

// GET MESSAGE
Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
  //construct chat room id from user IDS (sorted to ensure it matches the id used when sending messages)
  List<String> ids = [userId,otherUserId];
  ids.sort();
  String chatRoomId = ids.join("_");

  return _firestore
      .collection('chat_rooms')
      .doc(chatRoomId)
      .collection('message')
      .orderBy('timestamp',descending: false)
      .snapshots();
}
}