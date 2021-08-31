import 'package:cloud_firestore/cloud_firestore.dart';
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

  final vegetables = {
    "1": "Raw Banana/ అరటికాయ ",
    "2": "Bottle Gourd/ ఆనపకాయ ",
    "3": "Potato/ ఆలుగడ్డ ",
    "4": "Goose Berry/ ఉసిరికాయ ",
    "5": "Red Chilli/ ఎండు మిరపకాయ",
    "6": "Bitter Gourd/ కాకర కాయ",
    "7": "Coriander/ కొత్తిమీర ",
    "8": "Curry Leaves/ కరివేపాకు ",
    "9": "Suran/ కందగడ్డ ",
    "10": "Cauliflower/ కాలి ఫ్లవర్",
    "11": "Cabbage/ క్యాబేజ్ ",
    "12": "Coconut/ కొబ్బరికాయ ",
    "13": "Kenaf/ గోంగూర ",
    "14": "Cluster beans/ గోకర కాయం",
    "15": "Broad Beans/ చిక్కుడు కాయ",
    "16": "Taro Root/ చీమదుంప ",
    "17": "Red sorrel/ చుక్కకూర ",
    "18": "Tomato/ టమాట ",
    "19": "Amaranthus/ తోటకూర ",
    "20": "Tindoora/ దొండకాయ ",
    "21": "Cucumber/ దోసకాయ ",
    "22": "Green Chilli/ పచ్చి మిరపకాయ",
    "23": "Jack Fruit/ పనసకాయ ",
    "24": "Sorrel/ పాలకూర ",
    "25": "Mushroom/ పుట్టగొడుగులు ",
    "26": "Mint Leaves/ పుదీన ",
    "27": "Snake Gourd/ పొట్లకాయ ",
    "28": "Green Peas/ బఠాని ",
    "29": "Betroot/ బీట్ రూట్",
    "30": "Spinach/ బచ్చలి కూర",
    "31": "Potato/ బంగాళా దుంప",
    "32": "Ridge Gourd/ బీరకాయ ",
    "33": "Ash Gourd/ బూడిది గుమ్మడికాయ",
    "34": "Capsicum/ బెంగుళూరు మిర్చి",
    "35": "Lady's Finger / బెండకాయ ",
    "36": "Raw Mango/ మామిడి కాయ",
    "37": "Drumstick/ ములక్కాయ మొనక్కాయ",
    "38": "Radish/ ముల్లంగి ",
    "39": "Fenugreek leaves/ మెంతి కూర",
    "40": "Corn/ మొక్క జొన్న",
    "41": "Sweet Potato/ మోరం  గడ్డ",
    "42": "Brinjal/ వంకాయ ",
    "43": "Garlic/ వెల్లుల్లి ",
    "44": "hill glory bower/ సరస్వతి ఆకు",
    "45": "Bottle Gourd/ సొరకాయ ",
  };

  final fruits = {
    "1": "Muskmelon/ ఖర్బుజ",
    "2": "Banana/ అరటి పండు",
    "3": "pineapple/ అనాస",
    "4": "jackfruit/ పనస పండు",
    "5": "papaya/ బొబ్బాయ",
    "6": "pomegranate/ దానిమ్మ",
    "7": "Dates/ ఖర్జూరం",
    "8": "berry/ నేరేడు",
    "9": "Custard Apple/ సీతాఫలం",
    "10": "watermelon/ పుచ్చ కాయ",
    "11": "Sapodilla/ సపోటా",
    "12": "plum/ రేగు",
    "13": "guava/ జామ",
    "14": "grapes/ ద్రాక్ష",
    "15": "mango/ మామిడి",
    "16": "mosambi/ బత్తయ్",
    "17": "orange/ నారింజ",
    "18": "Sweet Orange/ కమల ఫలం",
    "19": "apple/ సేపు",
    "20": "strawberry/ బెర్",
  };

  final tiffins = {
    "1": "idly/ ఇడ్లీ",
    "2": "vada/ వాడా",
    "3": "mysore bonda/ మైసోర్ బోండా",
    "4": "upma/ ఉప్మా",
    "5": "poori/ పూరి",
    "6": "Uthappam/ ఉతప్పం",
    "7": "Semiya Upma/ సెమియా ఉప్మా",
    "8": "Puttu/ పుట్టు",
    "9": "Rava Dosa/ రవ దోస",
    "10": "Punugulu/ పునుగులు",
    "11": "Chapathi/ చపాతి",
    "12": "Pongal/ పొంగల్",
    "13": "Aloo Bonda/ ఆలు బోండా",
    "14": "Tomato Baath/ టొమాటో బాత్",
    "15": "Bisi Bele Baath/ బిసి బెలే బాత్",
    "16": "Pulihora/ పులిహోరా",
    "17": "Daddojanam/ దద్దోజనమ్",
    "18": "Appam/ అప్పం",
    "19": "Pesarattu/ పెసారట్టు",
    "20": "Dosa/ దోస",
  };

  List<DropdownMenuItem<String>> menuItems1 = List();

  final GlobalKey<FormFieldState> _vegetablekey = GlobalKey();
  String value = " ";
  String value1 = "";
  String valueSelected = " ";
  bool disableDropDown = true;

  void populateVegetables() {
    for (String key in vegetables.keys) {
      menuItems1.add(DropdownMenuItem<String>(
        value: vegetables[key],
        child: Text(vegetables[key]),
      ));
    }
  }

  void populateFruits() {
    for (String key in fruits.keys) {
      menuItems1.add(DropdownMenuItem<String>(
        value: fruits[key],
        child: Text(fruits[key]),
      ));
    }
  }

  void populateTiffins() {
    for (String key in tiffins.keys) {
      menuItems1.add(DropdownMenuItem<String>(
        value: tiffins[key],
        child: Text(tiffins[key]),
      ));
    }
  }

  populateOthers() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "enter what you need",
        labelStyle: TextStyle(fontSize: 15.0),
        hintText: "Must be at least 3 characters",
      ),
    );
  }

  void valueChanged1(_value1) {
    //_vegetablekey.currentState.reset();
    if (_value1 == "vegetables") {
      menuItems1 = List();
      populateVegetables();
    } else if (_value1 == "fruits") {
      menuItems1 = List();
      populateFruits();
    } else if (_value1 == "tiffins") {
      menuItems1 = List();
      populateTiffins();
    } else if (_value1 == "others") {
      populateOthers();
    }
    setState(() {
      value = _value1;
      valueSelected = value;
      disableDropDown = false;
    });
  }

  void thirdValueChanged(_value1) {
    setState(() {
      value1 = _value1;
    });
  }

  //list(){
  //Navigator.of(context).pushReplacement(
  //  MaterialPageRoute(builder: ((context) => ListScreen(
  //))));
  //}
  //LatLng _center;

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

    _getMinMaxLongLattoConsiderasperDistinact(lat1, long1, 3);

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
      /*appBar: AppBar(
          backgroundColor: Colors.green[800],
          //title: Text("${_currentAddress} "),
        ),*/
      appBar: PreferredSize(
          preferredSize: Size(double.infinity, 300),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    height: 250,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.orange),
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 60,
                        ),
                        //if (_currentPosition != null)
                        // Text("current address is ${CurrentAddress}",style: TextStyle(color: Colors.black),),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.deepOrange),
                          ),
                          height: 35,
                          width: 250,
                          child: GestureDetector(
                              child: Center(child: Text('get current locaton')),
                              onTap: () async {
                                getCurrentLocation();
                                return await userRef.doc(uid).update({
                                  "latitude": "${latitudeData1}",
                                  "longitude": "${longitudeData1}",
                                });
                              }),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          CurrentAddress != null
                              ? CurrentAddress
                              : CircularProgressIndicator(),
                          style: TextStyle(
                              color: Colors.deepOrange[800],
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        /*Row(
                            children: [
                              Expanded(
                                child: Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                      color: Colors.green, border: Border.all()),
                                  //color: Colors.green,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 20.0),
                                    //margin: EdgeInsets.only(left: 20.0),
                                    //width: 250,
                                    child: DropdownButtonFormField<String>(
                                      items: [
                                        DropdownMenuItem<String>(
                                            value: 'vegetables',
                                            child: Text(
                                              'vegetables',
                                              style: TextStyle(
                                                fontFamily: 'Helvetica',
                                              ),
                                            )),
                                        DropdownMenuItem<String>(
                                            value: 'fruits',
                                            child: Text(
                                              'fruits',
                                              style: TextStyle(
                                                fontFamily: 'Helvetica',
                                              ),
                                            )),
                                        DropdownMenuItem<String>(
                                            value: 'tiffins',
                                            child: Text(
                                              'tiffins',
                                              style: TextStyle(
                                                fontFamily: 'Helvetica',
                                              ),
                                            )),
                                        DropdownMenuItem<String>(
                                            value: 'others',
                                            child: Text(
                                              'All',
                                              style: TextStyle(
                                                fontFamily: 'Helvetica',
                                              ),
                                            )),
                                      ],
                                      onChanged: (_value1) => valueChanged1(_value1),
                                      validator: (value) =>
                                      value == null ? 'Field required' : null,
                                      hint: Text(
                                        "Select Category",
                                        style: TextStyle(
                                            fontFamily: 'Helvetica',
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                      color: Colors.green, border: Border.all()),
                                  //color: Colors.green,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 20.0),
                                    //width: 200,
                                    child: DropdownButtonFormField<String>(
                                      items: [
                                        DropdownMenuItem<String>(
                                            value: '2',
                                            child: Text(
                                              '2 km',
                                              style: TextStyle(
                                                fontFamily: 'Helvetica',
                                              ),
                                            )),
                                        DropdownMenuItem<String>(
                                            value: '5',
                                            child: Text(
                                              '5 km',
                                              style: TextStyle(
                                                fontFamily: 'Helvetica',
                                              ),
                                            )),
                                      ],
                                      onChanged: (_value1) => valueChanged1(_value1),
                                      validator: (value) =>
                                      value == null ? 'Field required' : null,
                                      hint: Text(
                                        "Distance",
                                        style: TextStyle(
                                            fontFamily: 'Helvetica',
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),*/
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
              ],
            ),
          )),
      /*appBar: PreferredSize(
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
                        //await locationInfo.getCurrentPosition();
                        //if(locationInfo.permissionGranted == true){
                        //Navigator.pushReplacement(context, MaterialPageRoute<void>(
                        //builder: (BuildContext context) =>  MapView(),
                        //),);
                        //}
                        //else{
                        //print('Permission denied');
                        //}

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
                  /*Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                              color: Colors.green, border: Border.all()),
                          //color: Colors.green,
                          child: Container(
                            padding: EdgeInsets.only(left: 20.0),
                            //margin: EdgeInsets.only(left: 20.0),
                            //width: 250,
                            child: DropdownButtonFormField<String>(
                              items: [
                                DropdownMenuItem<String>(
                                    value: 'vegetables',
                                    child: Text(
                                      'vegetables',
                                      style: TextStyle(
                                        fontFamily: 'Helvetica',
                                      ),
                                    )),
                                DropdownMenuItem<String>(
                                    value: 'fruits',
                                    child: Text(
                                      'fruits',
                                      style: TextStyle(
                                        fontFamily: 'Helvetica',
                                      ),
                                    )),
                                DropdownMenuItem<String>(
                                    value: 'tiffins',
                                    child: Text(
                                      'tiffins',
                                      style: TextStyle(
                                        fontFamily: 'Helvetica',
                                      ),
                                    )),
                                DropdownMenuItem<String>(
                                    value: 'others',
                                    child: Text(
                                      'All',
                                      style: TextStyle(
                                        fontFamily: 'Helvetica',
                                      ),
                                    )),
                              ],
                              onChanged: (_value1) => valueChanged1(_value1),
                              validator: (value) =>
                              value == null ? 'Field required' : null,
                              hint: Text(
                                "Select Category",
                                style: TextStyle(
                                    fontFamily: 'Helvetica',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                              color: Colors.green, border: Border.all()),
                          //color: Colors.green,
                          child: Container(
                            padding: EdgeInsets.only(left: 20.0),
                            //width: 200,
                            child: DropdownButtonFormField<String>(
                              items: [
                                DropdownMenuItem<String>(
                                    value: '2',
                                    child: Text(
                                      '2 km',
                                      style: TextStyle(
                                        fontFamily: 'Helvetica',
                                      ),
                                    )),
                                DropdownMenuItem<String>(
                                    value: '5',
                                    child: Text(
                                      '5 km',
                                      style: TextStyle(
                                        fontFamily: 'Helvetica',
                                      ),
                                    )),
                              ],
                              onChanged: (_value1) => valueChanged1(_value1),
                              validator: (value) =>
                              value == null ? 'Field required' : null,
                              hint: Text(
                                "Distance",
                                style: TextStyle(
                                    fontFamily: 'Helvetica',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),*/
                  SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            )),
        backgroundColor: Colors.greenAccent[50],
        body: Padding(
          padding: const EdgeInsets.only(left:8.0),
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
            /*child: Center(
              child: Container(
                child: StreamBuilder(
                    stream: _fetch1(),
                    builder: (BuildContext context, AsyncSnapshot snapShot){
                      if(!snapShot.hasData) return CircularProgressIndicator();
                      return Column(
                        children: [
                          ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapShot.data.docs.map((DocumentSnapshot document) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  width: 80,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        height: 80,
                                        child: Card(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(4),
                                            child:  Image.network(document['image'],fit: BoxFit.cover,),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Text(document['shop']),
                                      )

                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          )
                        ],
                      );
                    }),
              ),
            ),*/
            /*child: FutureBuilder(
                future: valueSelected == 'others' ? _fetch1() : _fetch(),
                builder: (_, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done)
                    return Center(child: CircularProgressIndicator(),);
                  // if(snapshot.hasData) return Center(child: CircularProgressIndicator());
                   /*List shopDistance = [];
                  for(int i=0 ; i<=snapshot.data.length; i++ ){
                    var distance = Geolocator.distanceBetween(lat1, long1, latitudeData1, longitudeData1);
                    var distanceinKm = distance/1000;
                    shopDistance.add(distanceinKm);
                  }*/
                  //if (double.parse(getDistance(currentLocation)) <= 5) {
                    return GridView.builder(
                        itemCount:
                        snapshot.data != null ? snapshot.data.length : null,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        itemBuilder: (BuildContext context, int index) {
                          DocumentSnapshot data =
                          snapshot.data != null ? snapshot.data[index] : null;
                          return GestureDetector(
                            onTap: () =>
                            {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ListScreen(
                                            data["Category"],
                                            data["SubCategory"],
                                          ))),
                            },
                            child: Card(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: 120.0,
                                      height: 150.0,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(data['image']) ==
                                                null
                                                ? AssetImage('images/pic3.jpg')
                                                : NetworkImage(data['image']),
                                          )),
                                    ),
                                  ),
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
                                  Padding(
                                    padding: const EdgeInsets.only(left: 40.0),
                                    child: Center(
                                      child: Row(
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
                                    ),
                                  ),
                                  //Text(getDistance(getCurrentLocation())),
                                ],
                              ),
                              //),
                            ),
                          );
                        });


                }),*/
          ),
        ));*/
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
