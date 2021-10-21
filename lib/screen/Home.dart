import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:core';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:latlng/latlng.dart';
import 'package:provider/provider.dart';
import 'package:gharelu/screen/Auth_provider.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:gharelu/screen/ListScreen.dart';
import 'package:gharelu/config/location_Provider.dart';
import 'package:gharelu/screen/mapView.dart';
import 'package:gharelu/config/merchant_services.dart';
import 'package:gharelu/screen/top_pick_merchants.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _minLat;
  var _maxLat;
  var _minLong;
  var _maxLong;

  String latitude1, longitude1;

  String username, email, uid, number, latitude2, longitude2;

  double lat1, long1;

  MerchantServices merchantServices = MerchantServices();

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

    //_getMinMaxLongLattoConsiderasperDistinact(latitude1, latitude2, 2);

    /*var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore
        .collection("Selling details")
        .where('Category', isEqualTo: valueSelected)
    //.where('SubCategory',isEqualTo: value1)
    //.where('radius', isLessThan: value)
    //.where(value, isLessThan: "10")
    //.where(_minLat,isLessThanOrEqualTo: latitudeData)
    //.where(_maxLat,isGreaterThanOrEqualTo: latitudeData)
    //.where(_minLong,isLessThanOrEqualTo: longitudeData)
    //.where(_maxLong,isGreaterThanOrEqualTo: longitudeData)
        .orderBy('Price')
        .get();
    return qn.docs;*/
  }

  _fetch1() async {
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

    //_getMinMaxLongLattoConsiderasperDistinact(latitude1, latitude2, 2);

    /*var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore
        .collection("Selling details")
        .orderBy('Price')
        .get();
    return qn.docs;*/
  }

  /*getCurrentLocation() async{
    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    setState(() {
      latitude1 = "${position.latitude}";
      longitude1 = "${position.longitude}";
      print("latitude:  "+latitude1);
      print("longitude: "+latitude1);
    });
  }*/

  List<DropdownMenuItem<String>> menuItems1 = List();

  final GlobalKey<FormFieldState> _vegetablekey = GlobalKey();
  String value = " ";
  String value1 = "";
  String valueSelected = " ";
  bool disableDropDown = true;

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

   // _getMinMaxLongLattoConsiderasperDistinact(lat1, long1, 3);

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
  void initState() {
    super.initState();
    getCurrentLocation();
    //_getMinMaxLongLattoConsiderasperDistinact(lat1, long1, 3);
    //_getCurrentLocation();
    // getCurrentLocation();
  }

  final CollectionReference userRef =
      FirebaseFirestore.instance.collection('Users');

  var units;
  TextEditingController distController = new TextEditingController();

  Position _currentPosition;
  String _currentAddress;

  double latitudeData;

  double longitudeData;

  double longitudeData1;

  double latitudeData1;

  String CurrentAddress = " ";

  _getMinMaxLongLattoConsiderasperDistinact(
      double latitude, double long, int radiusInKm) {
    var pi = 0.017453292519943295;
    var c = cos;
    double kmInLongitudeDegree = 111.320 * c((latitude / 180.0) * pi);

    var deltaLat = radiusInKm / 111.1;
    var deltaLong = radiusInKm / kmInLongitudeDegree;

    _minLat = latitude - deltaLat;
    _maxLat = latitude + deltaLat;
    _minLong = long - deltaLong;
    _maxLong = long + deltaLong;

    print("latitude : ${latitude}");
    print("longitude: ${long}");
    print("radius : ${radiusInKm}");
    print("_minLat : ${_minLat}");
    print("_maxLat : ${_maxLat}");
    print("_minLong : ${_minLong}");
    print("_maxLong : ${_maxLong}");
  }

  bool isButtonDisabled;

  String getDistance(location) {
    var distance =
        Geolocator.distanceBetween(lat1, long1, latitudeData1, longitudeData1);
    //print("distance is :"+ "${distance}");
    var distanceInKm = distance / 1000;
    return distanceInKm.toStringAsFixed(2);
  }

  getTopMerchants() {
    return FirebaseFirestore.instance
        .collection('Selling details')
        .where('Category', isEqualTo: valueSelected)
        //.where("${double.parse(getDistance('location'))}", isLessThanOrEqualTo: 5)
        .orderBy('Price')
        .snapshots();
  }

  String _myActivity;

  @override
  Widget build(BuildContext context) {
    //final auth = Provider.of<authProvider>(context);
    _fetch();
    CircularProgressIndicator();
    // _getMinMaxLongLattoConsiderasperDistinact(3.876, 6.765, 3);
    /* _getMinMaxLongLattoConsiderasperDistinact(
        _currentPosition.latitude != null
            ? _currentPosition.latitude
            : Text('waiting'),
        _currentPosition.longitude != null
            ? _currentPosition.longitude
            : Text('waiting'),
        2);*/
    //final locationInfo = Provider.of<LocationProviderService>(context,listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 300),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 60,
              ),
              //if (_currentPosition != null)
              // Text("current address is ${CurrentAddress}",style: TextStyle(color: Colors.black),),
              RaisedButton(
                  child: Text('get current locaton'),
                  onPressed: () async {
                    getCurrentLocation();
                    return await userRef.doc(uid).update({
                      "latitude": "${latitudeData1}",
                      "longitude": "${longitudeData1}",
                    });
                  }),
              Text(
                CurrentAddress,
                style: TextStyle(
                    color: Colors.green[800],
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 12,
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  height: 600,
                  child: TopPickMerchant(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<String>> fetchGalleryData() async {
    try {
      final response = await http
          .get(
              'https://kaleidosblog.s3-eu-west-1.amazonaws.com/flutter_gallery/data.json')
          .timeout(Duration(seconds: 5));

      if (response.statusCode == 200) {
        return compute(parseGalleryData, response.body);
      } else {
        throw Exception('Failed to load');
      }
    } on SocketException catch (e) {
      throw Exception('Failed to load');
    }
  }

  List<String> parseGalleryData(String responseBody) {
    final parsed = List<String>.from(json.decode(responseBody));
    return parsed;
  }
}
