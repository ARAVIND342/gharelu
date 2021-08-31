import 'package:cloud_firestore/cloud_firestore.dart';
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
  var latitude2;
  var longitude2;

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

  String value = " ";
  bool disableDropDown = true;

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

  getTopMerchants() {
    return FirebaseFirestore.instance
        .collection('Selling details')
        .where('Category', isEqualTo: valueSelected)
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
                  decoration:
                      BoxDecoration(color: Colors.green, border: Border.all()),
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
             /* Expanded(
                child: Container(
                  width: 100,
                  decoration:
                      BoxDecoration(color: Colors.green, border: Border.all()),
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
              ),*/
            ],
          ),
          Expanded(
            child: Container(
              child: StreamBuilder<QuerySnapshot>(
                  stream: getTopMerchants(),
                  builder: (context, snapShot) {
                    if (!snapShot.hasData)
                      return Center(child: CircularProgressIndicator());
                    /*List shopDistance = [];
                    for (int i = 0; i < snapShot.data.docs.length; i++) {
                      var distance = Geolocator.distanceBetween(
                          double.parse(latitude2),
                          double.parse(longitude2),
                          snapShot.data.docs[i]['location'].latitude,
                          snapShot.data.docs[i]['location'].longitude);
                      var distanceInKm = distance/1000;
                      shopDistance.add(distanceInKm);
                    }*/
                    //if (snapShot.data != null)
                    //return CircularProgressIndicator();
                    return Column(
                      children: [
                        Container(
                          child: Flexible(
                            child: GridView.count(
                              crossAxisCount: 2,
                              scrollDirection: Axis.vertical,
                              children: snapShot.data.docs
                                  .map((DocumentSnapshot document) {
                                    //if(latitude2 != null && longitude2 != null)
                                 //if (double.parse(getDistance(document['location'])) <= 10 ){
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: GestureDetector(
                                    onTap: () => {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ListScreen(
                                                    document["Category"],
                                                    document["SubCategory"],
                                                  ))),
                                    },
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
                                                    document['shop'] +
                                                        " - " +
                                                        document['SubCategory'],
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
                                                ),
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
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
