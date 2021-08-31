import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gharelu/screen/chatPage.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  String username, email, uid, number, latitude2, longitude2;

  double lat1, long1;

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
        lat1 = double.parse(latitude2);
        long1 = double.parse(longitude2);
        // units = ds.data()['units'];

        print(username);
        print(email);
        print(uid);
        print(number);
        print(latitude2);
        print(longitude2);
        print("lat1 is ${lat1}");
        print("long1 is ${long1}");
        //print(units);
      }).catchError((e) {
        print(e);
      });

    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore
        .collection("messages")
        .doc(uid)
        .collection("message")
        //  .orderBy('Price')
        .get();
    return qn.docs;
  }

  @override
  Widget build(BuildContext context) {
    _fetch();
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: Container(
        child: FutureBuilder(
          future: _fetch(),
          builder: (_, snapshot) {
            if (snapshot.connectionState != ConnectionState.done)
              return Center(child: CircularProgressIndicator(),);
            return ListView.builder(
                itemCount: snapshot.data != null ? snapshot.data.length : null,
                itemBuilder: (_, index) {
                  DocumentSnapshot data =
                      snapshot.data != null ? snapshot.data[index] : null;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        /*Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatPage(
                                    data['customer username'],
                                    data['customer uid'],
                                    data["message"],
                                    data['Category'],
                                    data['SubCategory'],
                                    data['Price'],
                                    data['Units'],
                                ))); */
                        print('clicked');
                      },
                      child: Container(
                        //height: 120,
                        child: Card(
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data["message"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                    Text(data['Category']),
                                    Text(data['SubCategory']),
                                    Text(data['Price'] + "  " + data['Units']),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}
