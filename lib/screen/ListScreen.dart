import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:gharelu/screen/Home.dart';
import 'package:gharelu/screen/homePage.dart';
import 'package:gharelu/screen/postWizardStep1.dart';
import 'package:gharelu/screen/viewMore.dart';
import 'package:gharelu/screen/updateDetails.dart';
import 'package:url_launcher/url_launcher.dart';

class ListScreen extends StatelessWidget {
  //final int index;
  final String Category1;

  //final String SubCategory1;

  //final String Price1;

  //final String SubCategory;

  ListScreen(this.Category1);

  String username, email, uid, number, latitude2, longitude2, shopName;

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
        shopName = ds.data()['shop name'];
        // units = ds.data()['units'];

        print(username);
        print(email);
        print(uid);
        print(number);
        print(latitude2);
        print(longitude2);
        print(shopName);
        //print(units);
      }).catchError((e) {
        print(e);
      });

    print("CATEGORY---- " + Category1);
    //print("SUBCATEGORY---- " + SubCategory1);

    //_getMinMaxLongLattoConsiderasperDistinact(latitude1, latitude2, 2);

    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore
        .collection("Selling details")
        .where('Category', isEqualTo: Category1)
        //.where('SubCategory', isEqualTo: SubCategory1)
        //.where('radius', isLessThan: value)
        //.where(value, isLessThan: "10")
        //.where(_minLat,isLessThanOrEqualTo: latitude2)
        //.where(_maxLat,isGreaterThanOrEqualTo: latitude2)
        //.where(_minLong,isLessThanOrEqualTo: longitude2)
        //.where(_maxLong,isGreaterThanOrEqualTo: longitude2)
        .orderBy("Price")
        .get();
    return qn.docs;
  }

  String postId = Uuid().v4();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of ${Category1}'),
        backgroundColor: Colors.orange,
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: FutureBuilder(
          future: _fetch(),
          builder: (_, snapshot) {
            if (snapshot.connectionState != ConnectionState.done)
              return Center(
                child: CircularProgressIndicator(),
              );
            return ListView.builder(
                itemCount: snapshot.data != null ? snapshot.data.length : null,
                itemBuilder: (_, index) {
                  DocumentSnapshot data =
                      snapshot.data != null ? snapshot.data[index] : null;
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.greenAccent),
                    ),
                    //width: 100,
                    //height: 150,
                    child: Card(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          ListTile(
                            leading: Container(
                              width: 70.0,
                              height: 70.0,
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  //border: Border.all(
                                  //color: Colors.red[500],
                                  //),
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(data['image']) == null
                                        ? (" ")
                                        : NetworkImage(data['image']),
                                  )),
                            ),
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data["Category"],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Rs ${data["Price"]}  ",
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                    Text(
                                      data["units"],
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                  ],
                                ),
                                //Text(data['Student uid']),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 15,
                              ),
                              GestureDetector(
                                /*shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(18.0)),*/
                                // color: Colors.red,
                                onTap: () {
                                  //Navigator.push(context,MaterialPageRoute(builder: (context) => PostWizardStep1()));
                                  FirebaseFirestore.instance
                                      .collection('messages')
                                      .doc(data['uid'])
                                      .collection('message')
                                      .doc(postId)
                                      .set({
                                    'message': 'Got order from  ${username}.',
                                    'customer uid': uid,
                                    'customer username': username,
                                    'seller uid': data['uid'],
                                    'Category': data["Category"],
                                    //'SubCategory': data["SubCategory"],
                                    'Price': "Rs ${data["Price"]}  ",
                                    'Units': data["units"],
                                    'Seller Name': data['Name']
                                  });
                                  return showDialog(
                                      context: context,
                                      builder: (BuildContext contxt) {
                                        return AlertDialog(
                                          title: Text("Success"),
                                          content: Text("Ordered Successfully"),
                                          actions: [
                                            FlatButton(
                                              child: Text('OK'),
                                              onPressed: () {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop();
                                                //Navigator.push(context,MaterialPageRoute(builder: (context) => PostWizardStep1()));
                                                //Navigator.of(context).pop();
                                              },
                                            )
                                          ],
                                        );
                                      });
                                },
                                child: Container(
                                    height: 40,
                                    width: 90,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border:
                                            Border.all(color: Colors.green[50]),
                                        color: Colors.red),
                                    child: Center(child: Text('order'))),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              GestureDetector(
                                // shape: RoundedRectangleBorder(
                                //   borderRadius:
                                //     new BorderRadius.circular(18.0)),
                                //color: Colors.blue,
                                onTap: () {
                                  "$data['number']" != null
                                      ? launch('tel://${data['number']}')
                                      : showDialog(
                                          context: context,
                                          builder: (BuildContext contxt) {
                                            return AlertDialog(
                                              title: Text("Sorry"),
                                              content:
                                                  Text("Number not assigned"),
                                              actions: [
                                                FlatButton(
                                                  child: Text('OK'),
                                                  onPressed: () {
                                                    //Navigator.push(context,MaterialPageRoute(builder: (context) => PostWizardStep1()));
                                                    Navigator.of(context).pop();
                                                  },
                                                )
                                              ],
                                            );
                                          });
                                },
                                child: Container(
                                    height: 40,
                                    width: 90,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border:
                                            Border.all(color: Colors.green[50]),
                                        color: Colors.blue),
                                    child: Center(child: Text('call'))),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              GestureDetector(
                                //shape: RoundedRectangleBorder(
                                //  borderRadius:
                                //    new BorderRadius.circular(18.0)),
                                //color: Colors.green,
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ViewMore(
                                                data['Name'] != null
                                                    ? data['Name']
                                                    : " ",
                                                "${data["Price"]}" != null
                                                    ? "${data["Price"]}  "
                                                    : " ",
                                                "${data['number']}" != null
                                                    ? "${data['number']}"
                                                    : " ",
                                                data['shop'] == null
                                                    ? " "
                                                    : data['shop'],
                                                data['image'] == null
                                                    ? " "
                                                    : data['image'],
                                                data['Start Date'] == null
                                                    ? " "
                                                    : data['Start Date'],
                                                data['End Date'] == null
                                                    ? " "
                                                    : data['End Date'],
                                              )));
                                  /*Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                          builder: ((context) => ViewMore(
                                                data['Name'] != null
                                                    ? data['Name']
                                                    : " ",
                                                "${data["Price"]}" != null
                                                    ? "${data["Price"]}  "
                                                    : " ",
                                                "${data['number']}" != null
                                                    ?"${data['number']}"
                                                    : " ",
                                                data['shop'] == null
                                                    ? " "
                                                    : data['shop'],
                                                data['image'] == null
                                                    ? " "
                                                    : data['image'],
                                                data['Start Date'] == null ? " ": data['Start Date'],
                                                data['End Date'] == null ? " ": data['End Date'],
                                              ))));*/
                                },
                                child: Container(
                                    height: 40,
                                    width: 90,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border:
                                            Border.all(color: Colors.green[50]),
                                        color: Colors.green),
                                    child: Center(child: Text('more'))),
                              ),
                            ],
                          ),
                          /*if (data['uid'] == uid)
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: RaisedButton(
                                      onPressed: () {
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(builder: ((context) => UpdateDetails( data['Name'] != null
                                                ? data['Name']
                                                : " ",
                                              "${data["Price"]}" != null &&
                                                  data["units"] != null
                                                  ? "${data["Price"]}  " +
                                                  data["units"]
                                                  : " ",
                                              "${data['number']}" != null
                                                  ?  "${data['number']}"
                                                  : " ",
                                              data['shop'] == null
                                                  ? " "
                                                  : data['shop'],
                                              data['image'] == null
                                                  ? " "
                                                  : data['image'],
                                              data['Start Date'] == null ? " ": data['Start Date'],
                                              data['End Date'] == null ? " ": data['End Date'],
                                              data['postId'] == null ? " ": data['postId'],
                                            ))));
                                      },
                                      child: Text('update')),
                                ),
                              ],
                            ),*/
                        ],
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
