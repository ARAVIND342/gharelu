import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gharelu/config/merchant_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gharelu/screen/ListScreen.dart';

class TopPickMerchant extends StatefulWidget {
  @override
  _TopPickMerchantState createState() => _TopPickMerchantState();
}

class _TopPickMerchantState extends State<TopPickMerchant> {
  //User user = FirebaseAuth.instance.currentUser;

  MerchantServices merchantServices = MerchantServices();

  String username, email, uid, number;
  double lat1, long1;
  String latitude2;
  String longitude2;

  _fetch1() async {
    final firebaseUser = await FirebaseAuth.instance.currentUser;
    if (firebaseUser != null)
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(firebaseUser.uid)
          .get()
          .then((ds) {
        username = ds.data()['Full Name'];
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
  }

  String getDistance(location) {
    if (latitude2 != null) {
      var distance = Geolocator.distanceBetween(double.parse(latitude2),
          double.parse(longitude2), location.latitude, location.longitude);
      var distanceInKm = distance / 1000;
      return distanceInKm.toStringAsFixed(2);
    } else {
      return null;
    }
  }

  List<DropdownMenuItem<String>> menuItems1 = List();
  String valueSelected = " ";

  String _myActivity;

  getTopMerchants() {
    return FirebaseFirestore.instance
        .collection('Selling details')
        .where('Category', isEqualTo: _myActivity)
        //.where("${double.parse(getDistance('location'))}", isLessThanOrEqualTo: 5)
        .orderBy('Price')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    _fetch1();
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  width: 100,
                  //color: Colors.green,
                  child: Container(
                    padding: EdgeInsets.only(left: 20.0),
                    child: ListTile(
                      title: Container(
                        width: 250,
                        child: DropDownFormField(
                          titleText: 'Select Category',
                          hintText: 'Please choose one',
                          value: _myActivity,
                          onSaved: (value) {
                            setState(() {
                              _myActivity = value;
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              _myActivity = value;
                            });
                          },
                          dataSource: [
                            {
                              "display": "Veg Only Breakfast",
                              "value": "Veg Only Breakfast",
                            },
                            {
                              "display": "Veg Only Lunch",
                              "value": "Veg Only Lunch",
                            },
                            {
                              "display": "Veg Only Dinner",
                              "value": "Veg Only Dinner",
                            },
                            {
                              "display": "Non-Veg Only Breakfast",
                              "value": "Non-Veg Only Breakfast",
                            },
                            {
                              "display": "Non-Veg Only Lunch",
                              "value": "Non-Veg Only Lunch",
                            },
                            {
                              "display": "Non-Veg Only Dinner",
                              "value": "Non-Veg Only Dinner",
                            },
                          ],
                          textField: 'display',
                          valueField: 'value',
                        ),
                      ),
                    ),
                    //margin: EdgeInsets.only(left: 20.0),
                    //width: 250,

                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
            ],
          ),
          Expanded(
            child: Container(
              child: lat1 != null && long1 != null ? StreamBuilder<QuerySnapshot>(
                  stream: getTopMerchants(),
                  builder: (context, snapShot) {
                    if (!snapShot.hasData)
                      return Center(child: CircularProgressIndicator());
                    return Column(
                      children: [
                        Container(
                          child: Flexible(
                            child: GridView.count(
                              crossAxisCount: 2,
                              scrollDirection: Axis.vertical,
                              children: snapShot.data.docs
                                  .map((DocumentSnapshot document) {
                                    if(latitude2 != null)
                                 if (double.parse(getDistance(document['location'])) <= 10 )
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: GestureDetector(
                                    onTap: (){Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ListScreen(
                                              document["Category"],
                                              //document["SubCategory"],
                                            )));},
                                    child: Container(
                                      width: 100,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 125,
                                            height: 110,
                                            child: Card(
                                                child: Container(
                                              width: 100,
                                              height: 110,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: NetworkImage(
                                                      document['image']),
                                                ),
                                              ),
                                            )
                                                /*child: ClipRRect(
                                              borderRadius: BorderRadius.circular(4),
                                              child: NetworkImage(document['image'],fit: BoxFit.cover,),
                                            ),*/
                                                ),
                                          ),
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: 37,
                                                  child: Text(
                                                    document['Name'] +
                                                        " - " +
                                                        "${document['Price']}",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Container(
                                                  child: Text(
                                                    //"${document['location']}",
                                                    //'20 km',
                                                    "${getDistance(document['location']) != null ? getDistance(document['location']) : " "} km ",
                                                     //document['address'],
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                /*Container(
                                                  child: Text(
                                                    //'20 km',
                                                    "${getDistance(document['location']) != null ? getDistance(document['location']) : " "} km ",
                                                    // document['shop'],
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),*/
                                              ],
                                            ),
                                          )

                                          // Text("${latitude2 == null ? " " : latitude2}"),
                                          // Text("${longitude2 == null ? " " : longitude2}"),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                                //}
                                //else{
                                //Container();
                                //}
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    );
                  }): Center(child:Text('Please select a category to get specific items')),
            ),
          ),
        ],
      ),
    );
  }
}
