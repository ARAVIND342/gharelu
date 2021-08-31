import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewItems extends StatelessWidget {
  final String purchaseCode;
  final String category;
  final String subcategory;

  ViewItems(this.purchaseCode, this.category, this.subcategory);

  String username, email, uid, number, latitude2, longitude2, shopName, code;

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
        code = ds.data()['code'] != null ? ds.data()['code'] : " ";
        // units = ds.data()['units'];

        print(username);
        print(email);
        print(uid);
        print(number);
        print(latitude2);
        print(longitude2);
        print(shopName);
        print(code);

        print('Category:'+ category);
        print('SubCategory:'+ subcategory);

        //print(units);
      }).catchError((e) {
        print(e);
      });

    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore
        .collection("Group Purchase")
        .doc(purchaseCode)
        .collection('Purchase')
        .where('Category',isEqualTo: category)
        .where('SubCategory',isEqualTo: subcategory)
        //.orderBy("Price")
        .get();
    return qn.docs;
  }

  final CollectionReference userRef =
      FirebaseFirestore.instance.collection('Group Purchase');

  @override
  Widget build(BuildContext context) {
    _fetch();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${purchaseCode}",
        ),
      ),
      backgroundColor: Colors.black,
      body: Container(
        child: FutureBuilder(
          future: _fetch(),
          builder: (_, snapshot) {
            if (snapshot.connectionState != ConnectionState.done)
              return Text('Loading... please wait');
            return ListView.builder(
                itemCount: snapshot.data != null ? snapshot.data.length : null,
                itemBuilder: (_, index) {
                  DocumentSnapshot data =
                      snapshot.data != null ? snapshot.data[index] : null;
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    //width: 100,
                    height: 150,
                    child: Card(
                      child: Column(
                        children: [
                          ListTile(
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data["Category"],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                                Text(
                                  data["SubCategory"],
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Min: Rs ${data["Minimum Price"]}  ",
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                    Text(
                                      "Max: Rs ${data["Maximum Price"]}  ",
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                  ],
                                ),
                                Text("Weight : ${data['Weight']}",style: TextStyle(fontSize: 14.0)),
                                Text("Person : ${data['Person']}",style: TextStyle(fontSize: 14.0)),
                              ],
                            ),
                            trailing: uid == data['uid']
                                ? RaisedButton(
                                    onPressed: () async{
                                      print('clicked');
                                      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => ViewItems(purchaseCode,category,subcategory)));
                                      return await userRef.doc(purchaseCode).collection('Purchase').doc(data['postId']).delete();
                                    },
                                    child: Text('delete'),
                                  )
                                : null,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              SizedBox(
                                width: 15,
                              ),
                              /*RaisedButton(
                                onPressed: () async {
                                  return await listRef.doc(uid).collection('product').doc(gpPurchaseId).set({
                                    'Category': data["Category"],
                                    'SubCategory': data["SubCategory"],
                                    'Price': "Rs ${data["Price"]}  " + data["units"],
                                    'Name':username,
                                  });
                                },
                                child: Text('Add to cart'),
                              ),*/
                              /*SizedBox(
                                width: 15,
                              ),
                              RaisedButton(
                                onPressed: () {},
                                child: Text('call'),
                              ),
                              SizedBox(
                                width: 15,
                              ),*/
                            ],
                          ),
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
