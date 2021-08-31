import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//gimport 'package:gharelu/group%20purchase/groupPurchaseItems.dart';

class GroupPurchase extends StatefulWidget {
  @override
  _GroupPurchaseState createState() => _GroupPurchaseState();
}

class _GroupPurchaseState extends State<GroupPurchase> {

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
        //code = ds.data()['code'] != null ? ds.data()['code'] : " ";
        // units = ds.data()['units'];

        print(username);
        print(email);
        print(uid);
        print(number);
        print(latitude2);
        print(longitude2);
        print(shopName);
        //print(code);
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
    //.where("Price",isGreaterThanOrEqualTo: maxPriceController.text == true)
    //.where("Price",isLessThanOrEqualTo: minPriceController.text == true)
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


  TextEditingController minPriceController = new TextEditingController();
  TextEditingController maxPriceController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    _fetch();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Group Purchases'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              Container(
                padding: EdgeInsets.only(left: 30.0),
                width: 350,
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Field cannot be empty';
                    } else
                      return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  //controller: _emailContoller,
                  //onSaved: (val) => email = val,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Create a group purchase code",
                    labelStyle: TextStyle(fontSize: 15.0),
                    hintText: "Must be at least 3 characters",
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'Create Offer',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(left: 30.0),
                width: 350,
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Field cannot be empty';
                    } else
                      return null;
                  },
                  keyboardType: TextInputType.number,
                  controller: minPriceController,
                  //onSaved: (val) => email = val,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter Minimum Price",
                    labelStyle: TextStyle(fontSize: 15.0),
                    hintText: "Must be at least 3 characters",
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(left: 30.0),
                width: 350,
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Field cannot be empty';
                    } else
                      return null;
                  },
                  keyboardType: TextInputType.number,
                  controller: maxPriceController,
                  //onSaved: (val) => email = val,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter Maximum Price",
                    labelStyle: TextStyle(fontSize: 15.0),
                    hintText: "Must be at least 3 characters",
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              RaisedButton(
                onPressed: () {
                  print('clicked');
                  //Navigator.push(context,MaterialPageRoute(builder: (context) => GroupPurchaseItems(int.parse(minPriceController.text), int.parse(maxPriceController.text), )));
                },
                child: Text('View Items'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
