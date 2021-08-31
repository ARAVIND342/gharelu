import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gharelu/groupPurchase/viewByPurchaseCode.dart';
import 'package:gharelu/screen/listForOffers.dart';
//import 'file:///F:/httpProject1/veg_flutter/lib/group%20purchase/groupPurchaseScreen.dart';


class GroupOffers extends StatefulWidget {
  @override
  _GroupOffersState createState() => _GroupOffersState();
}

class _GroupOffersState extends State<GroupOffers> {

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

    //print("CATEGORY---- " + Category1);
    //print("SUBCATEGORY---- " + SubCategory1);

    //_getMinMaxLongLattoConsiderasperDistinact(latitude1, latitude2, 2);

    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore
        .collection("Selling details")
        //.where('Category', isEqualTo: Category1)
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('offers'),
      ),
      backgroundColor: Colors.green[200],
      body: Column(
        children: [
          SizedBox(height: 30,),
          Container(
            padding: EdgeInsets.only(left: 30.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green[200]),
            ),
            width: 350,
            height: 80,
            child: GestureDetector(
              onTap: () => {
                //Navigator.pop(context),
                Navigator.push(context,MaterialPageRoute(builder: (context) => ListForOffers())),
                print('clicked'),
              },
              child: Card(
                color: Colors.green,
                child: ListTile(
                  leading: Text(
                    'Add new item',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  trailing: Icon(Icons.add_shopping_cart_rounded),
                ),
              ),
            ),
          ),
          SizedBox(height: 30,),
          Container(
            padding: EdgeInsets.only(left: 30.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green[200]),
            ),
            width: 350,
            height: 80,
            child: GestureDetector(
              onTap: () => {
                //Navigator.pop(context),
                Navigator.push(context,MaterialPageRoute(builder: (context) => ViewByPurchaseCode())),
                print('clicked'),
              },
              child: Card(
                color: Colors.green,
                child: ListTile(
                  leading: Text(
                    'View Products',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  trailing: Icon(Icons.shopping_cart),
                ),
              ),
            ),
          ),
        ],
      )
    );
  }

}
