import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gharelu/screen/Account.dart';
import 'package:gharelu/screen/homePage.dart';

class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _shopController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  final _key = GlobalKey<FormState>();

  String gpValue = '';

  String username,
      email,
      uid,
      number,
      latitude2,
      longitude2,
      shopName,
      code,
      gpvalue;

  final CollectionReference userRef =
      FirebaseFirestore.instance.collection('Users');



  _fetch() async {
    //getCurrentLocation();
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
        code = ds.data()['code'] != null ? ds.data()['code'] : null;
        gpvalue = ds.data()['type'] != null ? ds.data()['type'] : null;
        // units = ds.data()['units'];

        print(username);
        print(email);
        print(uid);
        print(number);
        print(latitude2);
        print(longitude2);
        print(shopName);
        //print(code);
        //print(gpvalue);
        //print(units);
      }).catchError((e) {
        print(e);
      });

    //_getMinMaxLongLattoConsiderasperDistinact(latitude1, latitude2, 2);
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  double longitudeData1;
  double latitudeData1;
  double latitudeData;
  double longitudeData;
  String _currentAddress;
  String CurrentAddress = " ";

  Position currentLocation;

  getCurrentLocation() async {
    Position geoPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitudeData = geoPosition.latitude;
      longitudeData = geoPosition.longitude;
    });

    latitudeData1 = latitudeData;
    longitudeData1 = longitudeData;

    //_getMinMaxLongLattoConsiderasperDistinact(lat1, long1, 3);

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        geoPosition.latitude,
        geoPosition.longitude,
      );

      Placemark place = placemarks[0];

      setState(() {
        print("lat is " + "${latitudeData1}");
        print("lon is " + "${longitudeData1}");
        _currentAddress =
        "${place.locality}, ${place.street}, ${place.postalCode}, ${place.country}";
        print("Current address is " + _currentAddress);

        CurrentAddress = _currentAddress;

        return Text(CurrentAddress);
      });
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    _fetch();
    //getCurrentLocation();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Update Profile',style: TextStyle(color: Colors.white),),
        centerTitle: true,
      /*  actions: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.done,
              size: 30.0,
              color: Colors.green,
            ),
          ),
        ],*/
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _fetch(),
          builder: (_, snapshot) {
            if (snapshot.connectionState != ConnectionState.done)
              return Center(child: CircularProgressIndicator(),);
            return Container(
              child: Form(
                key: _key,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          border: Border.all(color: Colors.black),
                        ),
                        //color: Colors.white60,
                        width: 315,
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Text('Mode of business'),
                            ),

                            /*Row(
                              children: [
                                Radio(
                                  value: 'Fixed',
                                  groupValue: gpValue,
                                ),
                                Text('Fixed'),
                              ],
                            )*/
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: 350,
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Name cannot be empty';
                          } else
                            return null;
                        },
                        keyboardType: TextInputType.text,
                        controller: _nameController,
                        //onSaved: (val) => username = val,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: username,
                          labelStyle: TextStyle(fontSize: 15.0),
                          hintText: "atleat 3 characters",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: 350,
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'shop Name cannot be empty';
                          } else
                            return null;
                        },
                        keyboardType: TextInputType.text,
                        controller: _shopController,
                        //onSaved: (val) => username = val,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: shopName,
                          labelStyle: TextStyle(fontSize: 15.0),
                          hintText: "atleat 3 characters",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: 350,
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Number cannot be empty';
                          } else
                            return null;
                        },
                        keyboardType: TextInputType.number,
                        controller: _numberController,
                        // onSaved: (val) => number = val,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: number,
                          labelStyle: TextStyle(fontSize: 15.0),
                          hintText: "atleat 3 characters",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: 350,
                      child: TextFormField(
                        maxLines: 4,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Address cannot be empty';
                          } else
                            return null;
                        },
                        keyboardType: TextInputType.text,
                        controller: _addressController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: code,
                          labelStyle: TextStyle(fontSize: 15.0),
                          hintText: CurrentAddress,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: 350,
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Code cannot be empty';
                          } else
                            return null;
                        },
                        keyboardType: TextInputType.text,
                        controller: _codeController,
                        onSaved: (val) => number = val,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: code,
                          labelStyle: TextStyle(fontSize: 15.0),
                          hintText: "Enter Code",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            child:
                                Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.green[50]),
                                        color: Colors.green[200]),
                                  height: 50,
                                  width: 150,
                                    child: Center(
                                        child: Text('Update')
                                    )
                                ),
                            onTap: () async {
                              await showDialog(
                                  context: context,
                                  builder: (BuildContext contxt) {
                                    return AlertDialog(
                                      title: Text("Success"),
                                      content: Text(
                                          "Updated Successfully"),
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
                              return await userRef.doc(uid).update({
                                'Full name': _nameController.text.isEmpty
                                    ? username
                                    : _nameController.text,
                                'shop name': _shopController.text.isEmpty
                                    ? shopName
                                    : _shopController.text,
                                'number': _numberController.text.isEmpty
                                    ? number
                                    : _numberController.text,
                                'type': 'FIXED',
                                'code': _codeController.text.isEmpty
                                    ? code
                                    : _codeController.text,
                              });
                              //print('clicked');
                            },
                          ),
                          //Spacer(),
                          GestureDetector(
                            child: Container(
                              height: 50,
                                width: 150,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.green[50]),
                                    color: Colors.green[200]),
                                child: Center(
                                    child: Text('Back')
                                )
                            ),
                            onTap: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
