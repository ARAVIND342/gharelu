import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gharelu/config/messageModel.dart';
import 'package:gharelu/config/utils.dart';


class FirebaseApi{


    static Future uploadMessage(String idUser, String message,String username) async{
      final refMessages = FirebaseFirestore.instance.collection('ChatMessages/$idUser/messages');
      final newMessage = Message(
          idUser: idUser,
          username: username,
          message: message,
          createdAt: DateTime.now(),
         // recUserId: recUserId,
      );
      await refMessages.add(newMessage.toJson());
      final refUsers = FirebaseFirestore.instance.collection('Users');
      await refUsers.doc(idUser).update({"last Message Time":DateTime.now()});
    }

    static Stream<List<Message>> getMessages(String idUser)=>
        FirebaseFirestore.instance.collection('ChatMessages/$idUser/messages')
        .orderBy(MessageField.createdAt,descending: true)
        .snapshots()
        .transform(Utils.transformer(Message.fromJson));
}
