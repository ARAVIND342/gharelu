import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gharelu/api/firebase_api.dart';
import 'package:gharelu/config/messageModel.dart';
import 'package:gharelu/config/message_widget.dart';
import 'package:gharelu/screen/messages.dart';

class MessagesWidget extends StatefulWidget {
  final String idUser;
  final String name;
  final String message;
  final String category;
  final String subcategory;
  final String price;
  final String units;

  const MessagesWidget({
    @required this.idUser,
    Key key, this.name, this.message, this.category, this.subcategory, this.price, this.units,
  }) : super(key: key);

  @override
  _MessagesWidgetState createState() => _MessagesWidgetState();
}

class _MessagesWidgetState extends State<MessagesWidget> {
  String username, email, uid, number, latitude2, longitude2;

  _fetch() async {
    final firebaseUser = await FirebaseAuth.instance.currentUser;
    if (firebaseUser != null)
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(firebaseUser.uid)
          .get()
          .then((ds) {
        username = ds.data()['Full name'];
        email = ds.data()['email'];
        uid = ds.data()['uid'];
        number = ds.data()['number'];
        latitude2 = ds.data()['latitude'];
        longitude2 = ds.data()['longitude'];
        // units = ds.data()['units'];

        print(username);
        print(email);
        print(uid);
        print(number);
        print(latitude2);
        print(longitude2);

        print("idUser is  " + widget.idUser);
        //print(units);
      }).catchError((e) {
        print(e);
      });
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<List<Message>>(
        stream: FirebaseApi.getMessages(widget.idUser),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return buildText('Something Went Wrong Try later');
              } else {
                final messages = snapshot.data;

                return messages.isEmpty
                    ? Column(
                      children: [
                        buildText("Hi, I am " + widget.name),
                        buildText("I need " + widget.subcategory),
                      ],
                    )
                    : ListView.builder(
                        physics: BouncingScrollPhysics(),
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          return MessageWidget(
                            message: message,
                            isMe: message.idUser == "${widget.idUser}",
                          );
                        },
                      );
              }
          }
        },
      );

  Widget buildText(String text) => Center(
        child: Column(
          children: [
            Text(
              text,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      );
}
