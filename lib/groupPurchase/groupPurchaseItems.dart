import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupPurchaseItems extends StatelessWidget {

  final int minPrice;
  final int maxPrice;
  final String category;
  final String subcategory;
  final int weight;

  GroupPurchaseItems(this.minPrice, this.maxPrice, this.category, this.subcategory, this.weight);

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

        print('category is  '+ category);
        print('subcategory is  '+ subcategory);
        print('weight is  + ${weight}');
        //print(units);
      }).catchError((e) {
        print(e);
      });

    //print("CATEGORY---- " + Category1);
    //print("SUBCATEGORY---- " + SubCategory1);

    //_getMinMaxLongLattoConsiderasperDistinact(latitude1, latitude2, 2);

    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore
        .collection("Selling details")
        .where('Price',isGreaterThanOrEqualTo: minPrice)
        .where('Price',isLessThanOrEqualTo: maxPrice)
        .where('Category',isEqualTo: category)
        .where('SubCategory',isEqualTo: subcategory)
        .orderBy("Price")
        .get();
    return qn.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Group Purchase Items'),
      ),
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
                    height: 100,
                    child: Card(
                      child: Column(
                        children: [
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
                                Text(
                                  data["SubCategory"],
                                  style: TextStyle(fontSize: 14.0),
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
                            trailing: Column(
                              children: <Widget>[
                                Text('Wt: ${weight}'),
                                Text('Rs ${data["Price"] * weight}'),
                              ],
                            ),
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
