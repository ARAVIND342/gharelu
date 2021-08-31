import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:gharelu/screen/Home.dart';
import 'package:gharelu/screen/ListScreen.dart';
import 'package:gharelu/screen/Selling.dart';
import 'package:gharelu/screen/homePage.dart';
import 'package:image/image.dart' as Im;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class UpdateDetails extends StatefulWidget {
  final String sellerName;
  final int price;
  final String units;
  final String number1;
  final String shopName1;
  final String pic;
  final String startDate;
  final String endDate;
  final String postId;
  final String category;
  final String subCategory;

  UpdateDetails(
      this.sellerName,
      this.price,
      this.units,
      this.number1,
      this.shopName1,
      this.pic,
      this.startDate,
      this.endDate,
      this.postId,
      this.category,
      this.subCategory);

  @override
  _UpdateDetailsState createState() => _UpdateDetailsState();
}

class _UpdateDetailsState extends State<UpdateDetails> {
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

        print(" username is  " + username);
        print(email);
        print(uid);
        print(number);
        print(latitude2);
        print(longitude2);
        print(shopName);

        print("seller is  " + widget.sellerName);
        print("seller is  " + "${widget.price}");
        print("seller is  " + widget.units);
        print("seller is  " + widget.number1);
        print("seller is  " + widget.shopName1);
        print("seller is  " + widget.pic);
        print("seller is  " + widget.startDate);
        print("seller is  " + widget.endDate);
        print("seller is  " + widget.postId);
        print("seller is  " + widget.category);
        print("seller is  " + widget.subCategory);
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
        //  .orderBy("Price")
        .get();
    return qn.docs;
  }

  final _key = GlobalKey<FormState>();

  var units;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailContoller = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _subCategoryController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _unitController = new TextEditingController();

  final CollectionReference userRef =
      FirebaseFirestore.instance.collection('Selling details');

  Widget imageProfile() {
    return Stack(
      children: <Widget>[
        CircleAvatar(
          radius: 80.0,
          backgroundImage: file == null
              ? NetworkImage(widget.pic)
              : FileImage(File(file.path)),
        ),
        Positioned(
          bottom: 5.0,
          right: 65.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => BottomSheet()),
              );
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.orange,
              size: 28.0,
            ),
          ),
        )
      ],
    );
  }

  clearImage() {
    setState(() {
      file = null;
    });
  }

  final StorageReference storageRef = FirebaseStorage.instance.ref();
  String postId = Uuid().v4();

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    setState(() {
      file = compressedImageFile;
    });
  }

  Future<String> uploadImage(imageFile) async {
    StorageUploadTask uploadTask =
        storageRef.child("post_$postId.jpg").putFile(imageFile);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  Widget BottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            'Choose Profile Photo',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton.icon(
                onPressed: () {
                  handleTakePhoto();
                },
                icon: Icon(Icons.camera),
                label: Text('Camera'),
              ),
            ],
          )
        ],
      ),
    );
  }

  File file;

  handleTakePhoto() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 675, maxWidth: 960);
    setState(() {
      this.file = file;
    });
  }

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

  String StartDate, EndDate;

  @override
  Widget build(BuildContext context) {
    _fetch();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[100],
        title: Text('Update Product Details',style: TextStyle(color: Colors.orange[900]),),
        centerTitle: true,
        /*leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: ((context) => HomePage())));
          },
        ),*/
      ),
      //backgroundColor: Colors.green[200],
      body: SingleChildScrollView(
        child: Container(
          color: Colors.greenAccent[100],
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                imageProfile(),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Full Name cannot be empty';
                          } else
                            return null;
                        },
                        decoration: InputDecoration(
                            labelText: widget.sellerName,
                            labelStyle: TextStyle(
                              color: Colors.black,
                            )),
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      DateTimePicker(
                        type: DateTimePickerType.dateTimeSeparate,
                        dateMask: 'd MMM, yyyy',
                        initialValue: widget.startDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        icon: Icon(Icons.event),
                        dateLabelText: widget.startDate,
                        timeLabelText: "Hour",
                        /*selectableDayPredicate: (date) {
                            // Disable weekend days to select from the calendar
                            if (date.weekday == 6 || date.weekday == 7) {
                              return false;
                            }
                            return true;
                          },*/
                        //onChanged: (val) => print(val),
                        onChanged: (val) {
                          setState(() {
                            StartDate = val;
                            print("Start date:  " + val);
                          });
                        },
                        validator: (val) {
                          print(val);
                          return null;
                        },
                        onSaved: (val) => print(val),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      DateTimePicker(
                        type: DateTimePickerType.dateTimeSeparate,
                        dateMask: 'd MMM, yyyy',
                        initialValue: widget.endDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        icon: Icon(Icons.event),
                        dateLabelText: widget.endDate,
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
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Category  :" + widget.category,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "SubCategory  :" + widget.subCategory,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      /*ListTile(
                        /*leading: Icon(
                            Icons.food_bank,
                            color: Colors.green,
                            size: 35.0,
                          ),*/
                        title: Container(
                          width: 250,
                          child: DropdownButtonFormField<String>(
                            items: [
                              DropdownMenuItem<String>(
                                  value: 'vegetables',
                                  child: Text(
                                    'vegetables/ కూరగాయలు',
                                    style: TextStyle(
                                      fontFamily: 'Helvetica',
                                    ),
                                  )
                              ),
                              DropdownMenuItem<String>(
                                  value: 'fruits',
                                  child: Text(
                                    'fruits/ పండ్లు',
                                    style: TextStyle(
                                      fontFamily: 'Helvetica',
                                    ),
                                  )
                              ),
                              DropdownMenuItem<String>(
                                  value: 'tiffins',
                                  child: Text(
                                    'tiffins/ టిఫిన్లు',
                                    style: TextStyle(
                                      fontFamily: 'Helvetica',
                                    ),
                                  )
                              )
                            ],
                            onChanged: (_value1) => valueChanged1(_value1),
                            validator: (value) => value == null ? 'Field required': null,
                            hint: Text(
                              widget.category,
                              //"Select Category",
                              style: TextStyle(fontFamily: 'Helvetica'),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12,),
                      ListTile(
                        title: Container(
                          width: 250,
                          child: DropdownButtonFormField<String>(
                            key: _vegetablekey,
                            items: menuItems1,
                            onChanged: disableDropDown ? null :(_value1) => thirdValueChanged(_value1),
                            validator: (value) => value == null ? 'Field required' : null ,
                            //hint: Text("Select subcategory"),
                            hint: Text(widget.subCategory),
                            disabledHint: Text(
                                widget.subCategory,
                              //"Please select category",
                              style: TextStyle(fontFamily: 'Helvetica'),
                            ),
                          ),
                        ),
                      ),*/
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _unitController,
                        decoration: InputDecoration(
                            labelText: "${widget.price}",
                            labelStyle: TextStyle(color: Colors.black),
                            //hintText: 'enter number',
                            suffixIcon: DropdownButton<String>(
                              isDense: true,
                              value: units,
                              //onChanged: units,
                              onChanged: (String newValue) {
                                setState(() {
                                  units = newValue;
                                });
                              },
                              hint: Text(
                                widget.units,
                                style: TextStyle(color: Colors.black),
                              ),
                              items: <String>[
                                'per Number',
                                'per Litre',
                                'per KiloGram'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                  ),
                                );
                              }).toList(),
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.green[400],
                                ),
                                color: Colors.green[400],
                              ),
                              width: 200.0,
                              height: 50,
                              child: Center(
                                  child: Text(
                                'Update',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ))),
                          onTap: () async {
                            String mediaUrl = file != null
                                ? await uploadImage(file)
                                : widget.pic;
                            return await userRef.doc(widget.postId).update({
                              'image': mediaUrl,
                              'Price': _unitController.text.isEmpty
                                  ? widget.price
                                  : int.parse(_unitController.text),
                              'Start Date': StartDate == null
                                  ? widget.startDate
                                  : StartDate,
                              'End Date':
                                  EndDate == null ? widget.endDate : EndDate,
                              //'Category': valueSelected != null ? valueSelected : widget.category,
                              //'SubCategory': value1.isEmpty ? widget.subCategory : value1,
                              'units': units == null ? widget.units : units,
                            }).then((value) {
                              print('success');
                              return showDialog(
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
                                            Navigator.of(context).pop(true);
                                            //Navigator.push(context,MaterialPageRoute(builder: (context) => Selling()));
                                          },
                                        )
                                      ],
                                    );
                                  });
                              //Navigator.pop(context, true);
                              //Navigator.push(context,MaterialPageRoute(builder: (context) => Home()));
                            });
                          })
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
