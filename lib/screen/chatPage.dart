import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uuid/uuid.dart';
import 'package:gharelu/chats/chat_messageModel.dart';
import 'package:gharelu/chats/new_message.dart';
import 'package:gharelu/chats/profile_header.dart';
import 'package:gharelu/config/messageModel.dart';
import 'package:gharelu/config/message_widget.dart';
import 'package:gharelu/config/utils.dart';
import 'package:gharelu/api/firebase_api.dart';
import 'package:gharelu/screen/messages_widget.dart';

class ChatPage extends StatefulWidget {
  final String name;
  final String idUser;
  final String message;
  final String category;
  final String subcategory;
  final String price;
  final String units;


  const ChatPage(this.name, this.idUser, this.message, this.category, this.subcategory, this.price, this.units);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
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

        print("idUser is  "+ widget.idUser);
        //print(units);
      }).catchError((e) {
        print(e);
      });
  }

  String message = " ";
  TextEditingController _chatController = TextEditingController();
  String postId = Uuid().v4();

  List<ChatMessage> messages = [
    ChatMessage(messageContent: "Hello, Will", messageType: "receiver"),
    ChatMessage(messageContent: "How have you been?", messageType: "receiver"),
  ];

  static Stream<List<Message>> getMessages(String idUser) =>
      FirebaseFirestore.instance
          .collection('Chats/$idUser/Chat Messages')
          .orderBy(MessageField.createdAt, descending: true)
          .snapshots()
          .transform(Utils.transformer(Message.fromJson));

  Widget buildText(String text) => Center(
    child: Text(
      text,
      style: TextStyle(fontSize: 24),
    ),
  );

  //var Date = DateTime.now();

  void sendMessage() async{
    FocusScope.of(context).unfocus();
    await FirebaseApi.uploadMessage(widget.idUser, message, widget.name);
    _chatController.clear();
  }


  @override
  Widget build(BuildContext context) => Scaffold(
    extendBodyBehindAppBar: true,
    backgroundColor: Colors.blue,
    body: SafeArea(
      child: Column(
        children: [
          ProfileHeaderWidget(name: widget.name),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: MessagesWidget(idUser: widget.idUser),
            ),
          ),
          NewMessageWidget(idUser: widget.idUser)
        ],
      ),
    ),
  );
  /*Widget build(BuildContext context) {
    _fetch();
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            ProfileHeaderWidget(name: widget.name),
            /*Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    )),
                child: widget.idUser == null ? Text("sdsdsd"):MessagesWidget(uid),
              ),
            ),*/
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  )
                ),
                //child: Text(widget.idUser + " + " + uid),
                //child: MessagesWidget(idUser: widget.idUser,),
                child: MessagesWidget(idUser: widget.idUser,price: widget.price,category: widget.category,subcategory: widget.subcategory,message: widget.message,name: widget.name,units: widget.units,),
              )
            ),
            Expanded(child: Container(child: NewMessageWidget(idUser: widget.idUser, username: widget.name,)))
            /*Row(
              children: <Widget>[
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: TextField(
                  controller: _chatController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: "Write Message...",
                    hintStyle: TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 10),
                      gapPadding: 10,
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onChanged: (value) => setState(() {
                    message = value;
                  }),
                )),
                SizedBox(
                  width: 15,
                ),
                GestureDetector(
                  onTap: message.trim().isEmpty? null : sendMessage,
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.greenAccent[700  ],
                    ),
                    child: Icon(Icons.send,color: Colors.white,),
                  ),
                )
                /*FloatingActionButton(
                  onPressed: () async {
                    print('clicked');
                    _chatController.clear();
                    message.trim().isEmpty
                        ? null
                        : FirebaseFirestore.instance
                            .collection('chats')
                            .doc(widget.idUser)
                            .collection('Chat Messages')
                            .doc(postId)
                            .set({
                            'userId': widget.idUser,
                            'name': widget.name,
                            'message': message,
                            'createdAt' : DateTime.now(),
                          });



                    //await FirebaseFirestore.instance.collection('Users').doc(widget.idUser).update({});
                  },
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 18,
                  ),
                  backgroundColor: Colors.blue,
                  elevation: 0,
                ),*/
              ],
            ),*/
          ],
        ),
      ),
    );
  }*/

/*void sendMessage() async{
    FocusScope.of(context).unfocus();
    await FirebaseApi.uploadMessage(widget.idUser, message);
  }*/

}
