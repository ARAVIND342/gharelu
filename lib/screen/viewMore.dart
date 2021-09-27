import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gharelu/screen/homePage.dart';

class ViewMore extends StatelessWidget {

  final String sellerName;
  final String price;
  final String number;
  final String shopName;
  final String pic;
  final String startDate;
  final String endDate;

   ViewMore(this.sellerName, this.price, this.number, this.shopName, this.pic, this.startDate, this.endDate);



  String username, email, uid, number1, latitude2, longitude2;

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
        number1 = ds.data()['number'];
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

    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore
        .collection("Selling details")
    //.where('Category', isEqualTo: valueSelected)
    //.where('SubCategory',isEqualTo: value1)
    //.where('radius', isLessThan: value)
    //.where(value, isLessThan: "10")
    //.where(_minLat,isLessThanOrEqualTo: latitude2)
    //.where(_maxLat,isGreaterThanOrEqualTo: latitude2)
    //.where(_minLong,isLessThanOrEqualTo: longitude2)
    //.where(_maxLong,isGreaterThanOrEqualTo: longitude2)
        .orderBy('Price')
        .get();
    return qn.docs;
  }

  @override
  Widget build(BuildContext context) {
    _fetch();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Details'),
        backgroundColor: Colors.orange,
        /*leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: ((context) => HomePage())));
          },
        ),*/
      ),
      body: SingleChildScrollView( 
        child: Container(
          child: FutureBuilder(
            future: _fetch(),
            builder: (_, snapshot) {
              if (snapshot.connectionState != ConnectionState.done)
                return Center(child: CircularProgressIndicator(),);
              return Padding(
                padding: const EdgeInsets.only(left:20.0,top: 40.0,right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 700.0,
                      height: 350.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          //border: Border.all(
                          //color: Colors.red[500],
                          //),
                          image: new DecorationImage(
                            fit: BoxFit.cover,
                            image: new NetworkImage(pic),
                          )),
                    ),
                    //Text('dsdsd'),
                    SizedBox(height: 20,),
                    Center(
                      child: Container(
                        //padding: EdgeInsets.only(left: 10.0),
                        width: 300,
                        height: 180,
                        //decoration: BoxDecoration(
                          //border: Border.all(
                            //color: Colors.greenAccent[100],
                          //)
                        //),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                               Text("Seller :    "+sellerName,style: TextStyle(fontWeight: FontWeight.bold),),
                               Text("ShopName :  "+shopName,style: TextStyle(fontWeight: FontWeight.bold),),
                               Text("Number :    "+number,style: TextStyle(fontWeight: FontWeight.bold),),
                               Text("Price :     "+price,style: TextStyle(fontWeight: FontWeight.bold),),
                               Text("Start Date :     "+startDate,style: TextStyle(fontWeight: FontWeight.bold),),
                               Text("End Date :     "+endDate,style: TextStyle(fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
