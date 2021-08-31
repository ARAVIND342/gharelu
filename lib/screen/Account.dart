import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gharelu/screen/signUpOrLogin.dart';
import 'package:gharelu/groupPurchase/groupOffers.dart';
import 'package:gharelu/screen/updateProfile.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {



 /* String username, email, uid, number, latitude2, longitude2;

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
        //print(units);
      }).catchError((e) {
        print(e);
      });

    //_getMinMaxLongLattoConsiderasperDistinact(latitude1, latitude2, 2);

    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore
        .collection("Selling details")
    //.where('Category', isEqualTo: valueSelected)
    //.where('SubCategory',isEqualTo: value1)
    //.where('radius', isLessThan: value)
    //.where(value, isLessThan: "10")
    //.where(_minLat,isLessThanOrEqualTo: latitudeData)
    //.where(_maxLat,isGreaterThanOrEqualTo: latitudeData)
    //.where(_minLong,isLessThanOrEqualTo: longitudeData)
    //.where(_maxLong,isGreaterThanOrEqualTo: longitudeData)
        .orderBy('Price')
        .get();
    return qn.docs;
  }*/

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signOut() async{
    await auth.signOut();
    //Navigator.push(context,MaterialPageRoute(builder: (context) => signUpOrLogin()));
    Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => new signUpOrLogin()));
  }

  @override
  Widget build(BuildContext context) {
    //_fetch();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[100],
        title: Text('Account',style: TextStyle(color: Colors.orange[900]),),
        centerTitle: true,
      ),
      //backgroundColor: Colors.orange,
      body: ListView(
        children: <Widget>[
          SizedBox(height: 20,),
          SizedBox(height: 20,),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.orange),
            ),
            width: 200,
            height: 80,

            child: GestureDetector(
              onTap: () => {
                //Navigator.pop(context),
                Navigator.push(context,MaterialPageRoute(builder: (context) => UpdateProfile())),
                print('clicked'),
              },
              child: Card(
                color: Colors.orange[400],
                child: ListTile(
                  leading: Text(
                    'Update Profile',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  trailing: Icon(Icons.person),
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.orange),
            ),
            width: 200,
            height: 80,
            child: GestureDetector(
              onTap: () => {
                //Navigator.pop(context),
                Navigator.push(context,MaterialPageRoute(builder: (context) => GroupOffers())),
                print('clicked'),
              },
              child: Card(
                color: Colors.orange[400],
                child: ListTile(
                  leading: Text(
                    'Group purchase',
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
          SizedBox(height: 20,),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.orange),
            ),
            width: 200,
            height: 80,
            child: GestureDetector(
              onTap: () => {
                signOut(),
                //Navigator.pop(context),
                print('clicked'),
              },
              child: Card(
                color: Colors.orange[400],
                child: ListTile(
                  leading: Text(
                    'Log Out',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  trailing: Icon(Icons.logout),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
