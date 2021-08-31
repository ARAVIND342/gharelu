import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:gharelu/groupPurchase/groupPurchaseItems.dart';
import 'package:gharelu/screen/viewMore.dart';

class ListForOffers extends StatefulWidget {
  @override
  _ListForOffersState createState() => _ListForOffersState();
}

class _ListForOffersState extends State<ListForOffers> {
  String username, email, uid, number, latitude2, longitude2, shopName, code;

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
        code = ds.data()['code'] != null ? ds.data()['code'] : " ";
        // units = ds.data()['units'];

        print(username);
        print(email);
        print(uid);
        print(number);
        print(latitude2);
        print(longitude2);
        print(shopName);
        print(code);
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

  // final CollectionReference listRef = FirebaseFirestore.instance.collection('Purchase');
  //final CollectionReference listRef1 = FirebaseFirestore.instance.collection('Group purchase');
  String gpPurchaseId = Uuid().v4();

  TextEditingController minPriceController = new TextEditingController();
  TextEditingController maxPriceController = new TextEditingController();
  TextEditingController weightController = new TextEditingController();
  TextEditingController codeController = new TextEditingController();

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
    "41": "Sweet Potato/ మోరం గడ్డ",
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

  void valueChanged1(_value1) {
    _vegetablekey.currentState.reset();
    if (_value1 == "vegetables") {
      menuItems1 = List();
      populateVegetables();
    } else if (_value1 == "fruits") {
      menuItems1 = List();
      populateFruits();
    } else if (_value1 == "tiffins") {
      menuItems1 = List();
      populateTiffins();
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

  String EndDate;
  var units;

  String postId = Uuid().v4();

  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    _fetch();
    return Scaffold(
      appBar: AppBar(
        title: Text('Add items'),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.greenAccent,
      body: SingleChildScrollView(
        child: Container(
            child: Column(
          children: [
            FutureBuilder(
                future: _fetch(),
                builder: (_, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done)
                    return Text('Loading... please wait');
                  return Column(children: <Widget>[
                    SizedBox(
                      height: 40,
                    ),
                    /*Text(
                      "Purchase code: ${code}",
                      style: TextStyle(fontSize: 21),
                    ),*/
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
                        keyboardType: TextInputType.text,
                        controller: codeController,
                        //onSaved: (val) => email = val,
                        decoration: InputDecoration(  
                            border: OutlineInputBorder(),
                            labelText: "Purchase Code : ${code}",
                            labelStyle: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                          //hintText: "Must be at least 3 characters",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ]);
                }),
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
            ListTile(
              /*leading: Icon(
                                  Icons.food_bank,
                                  color: Colors.green,
                                  size: 35.0,
                                ),*/
              title: Container(
                padding: EdgeInsets.only(left: 30.0),
                width: 350,
                child: DropdownButtonFormField<String>(
                  items: [
                    DropdownMenuItem<String>(
                        value: 'vegetables',
                        child: Text(
                          'vegetables/ కూరగాయలు',
                          style: TextStyle(
                            fontFamily: 'Helvetica',
                          ),
                        )),
                    DropdownMenuItem<String>(
                        value: 'fruits',
                        child: Text(
                          'fruits/ పండ్లు',
                          style: TextStyle(
                            fontFamily: 'Helvetica',
                          ),
                        )),
                    DropdownMenuItem<String>(
                        value: 'tiffins',
                        child: Text(
                          'tiffins/ టిఫిన్లు',
                          style: TextStyle(
                            fontFamily: 'Helvetica',
                          ),
                        ))
                  ],
                  onChanged: (_value1) => valueChanged1(_value1),
                  validator: (value) => value == null ? 'Field required' : null,
                  hint: Text(
                    "Select Category",
                    style: TextStyle(fontFamily: 'Helvetica'),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            ListTile(
              title: Container(
                padding: EdgeInsets.only(left: 30.0),
                width: 350,
                child: DropdownButtonFormField<String>(
                  key: _vegetablekey,
                  items: menuItems1,
                  onChanged: disableDropDown
                      ? null
                      : (_value1) => thirdValueChanged(_value1),
                  validator: (value) => value == null ? 'Field required' : null,
                  hint: Text("Select subcategory"),
                  disabledHint: Text(
                    "Please select subcategory",
                    style: TextStyle(fontFamily: 'Helvetica'),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: 250,
              child: DateTimePicker(
                type: DateTimePickerType.dateTimeSeparate,
                dateMask: 'd MMM, yyyy',
                initialValue: DateTime.now().toString(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                icon: Icon(Icons.event),
                dateLabelText: 'End Date',
                timeLabelText: "Hour",
                /*selectableDayPredicate: (date) {
                              // Disable weekend days to select from the calendar
                              if (date.weekday == 6 || date.weekday == 7) {
                                return false;
                              }
                              return true;
                            },*/
                // onChanged: (val) => print("val" + val),
                onChanged: (val) {
                  setState(() {
                    EndDate = val;
                    print("End date:  " + val);
                  });
                },
                validator: (val) {
                  print(" val1" + val);
                  return null;
                },
                onSaved: (val) => print(val),
                /*onSaved: (val) {
                              setState(() {
                                EndDate = val;
                                print("End date:  "+ val);
                              });
                            }*/
              ),
            ),
            SizedBox(height: 30,),
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
                controller: weightController,
                //onSaved: (val) => email = val,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter Weight",
                  labelStyle: TextStyle(fontSize: 15.0),
                    /*suffixIcon: DropdownButton<String>(
                      isDense: true,
                      value: units,
                      onChanged: (String newValue) {
                        setState(() {
                          units = newValue;
                        });
                      },
                      hint: Text(
                        'select units',
                        style: TextStyle(color: Colors.black),
                      ),
                      items: <String>[
                        ' Number',
                        ' Litre',
                        ' KiloGram'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                          ),
                        );
                      }).toList(),
                    )*/
                  //hintText: "Must be at least 3 characters",
                ),
              ),
            ),
            SizedBox(height: 10,),
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
                  hintText: "Must be at least 1 characters",
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
                  hintText: "Must be at least 1 characters",
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            RaisedButton(
              onPressed: () {
                print('clicked');
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => ListForOffers() ));
                _firestore.collection('Group Purchase').doc(codeController.text.isEmpty != true ? codeController.text : code).collection('Purchase').doc(postId).set({
                  "Purchase Code":codeController.text.isEmpty != true ? codeController.text : code,
                  "uid":uid,
                  "Category":valueSelected,
                  "SubCategory":value1,
                  "End Date":EndDate,
                  "Weight":weightController.text,
                  "Minimum Price":minPriceController.text,
                  "Maximum Price":maxPriceController.text,
                  "postId":postId,
                  "Person":username,
                  //"Units":units,
                });
                /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GroupPurchaseItems(
                            int.parse(minPriceController.text),
                            int.parse(maxPriceController.text),
                            valueSelected,
                            value1,
                            int.parse(weightController.text),
                        )));*/
              },
              child: Text('Save to my list'),
            )
          ],
        )),
      ),
    );
  }
}
