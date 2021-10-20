import 'dart:io';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

//import 'package:geopoint/geopoint.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:gharelu/screen/Home.dart';
import 'package:gharelu/screen/homePage.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:image/image.dart' as Im;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:gharelu/screen/Auth_provider.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:school/screens/loginPage.dart';
// import 'package:uuid/uuid.dart';

// User currentUser;

class PostWizardStep1 extends StatefulWidget {
  // final String uid;

  // PostWizardStep1({ this.uid});

  @override
  _PostWizardStep1State createState() => _PostWizardStep1State();
}

class _PostWizardStep1State extends State<PostWizardStep1> {
  // final FirebaseAuth _auth =FirebaseAuth.instance;

  final _key = GlobalKey<FormState>();
  bool isUploading = false;

  // String postId = Uuid().v4();
  bool isSigningUp = false;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailContoller = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _subCategoryController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _unitController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();

  var units;

  String username, email, uid, number, shopName;
  String latitude2, longitude2;

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

        print(username);
        print(email);
        print(uid);
        print(number);
        print(latitude2);
        print(longitude2);
        print(shopName);
        //print(units);
      }).catchError((e) {
        print(e);
      });
  }

  // final _firestore = FirebaseFirestore.instance;
  //
  // final StorageReference storageRef = FirebaseStorage.instance.ref();
  //
  // PickedFile _imageFile;
  // final ImagePicker _picker = ImagePicker();



  static DateFormat dateFormat = new DateFormat('yyyy/MM/dd');

  //DateTime startDate = DateTime.now();
  DateTime startDate;

  Padding buildHarvestDate(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 32.0),
      child: InkWell(
        onTap: () {
          showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(Duration(days: 90)),
                  lastDate: DateTime(2040))
              .then((date) {
            setState(() {
              startDate = date;
            });
          });
        },
        child: Container(
          height: 56.0,
          width: double.infinity,
          decoration: new BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 8.0),
          child: startDate == null
              ? Text(
                  '* Harvest Date',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                )
              : Text(dateFormat.format(startDate).toString()),
        ),
      ),
    );
  }

  //DateTime expiryDate = DateTime.now();
  DateTime expiryDate;

  Padding buildExpiryDate(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 32.0),
      child: InkWell(
        onTap: () {
          showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2028))
              .then((date) {
            setState(() {
              print('date current' + date.toString());
              expiryDate = date;
            });
          });
        },
        child: Container(
            height: 56.0,
            width: double.infinity,
            decoration: new BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 8.0),
            child: expiryDate == null
                ? Text(
                    '* Expiry Date',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),
                  )
                : Text(dateFormat.format(expiryDate).toString())),
      ),
    );
  }

  final firebaseUser = FirebaseAuth.instance.currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final busRef = FirebaseFirestore.instance.collection('Selling details');

  String placeName;
  String shopAddress;

  createPostInFirestore({
    String firstName,
    String StartDate,
    String EndDate,
    //String category,
    //String subcategory,
    String price,
    String mediaUrl,
    String harvestDate,
    String expiryDate,
    String latitude,
    String longitude,
    String category,
    String location,
    String address,
  }) {
    busRef
        //.doc(_auth.currentUser.uid)
        //.collection("Selling Details")
        .doc(postId)
        .set({
      "postId": postId,
      //"ownerId":widget.currentUser.uid,
      "Name": firstName,
      "Start Date": StartDate,
      "End Date": EndDate,
      "Category": category,
      //"SubCategory": value1,
      "Price": int.parse(price),
      "image": mediaUrl,
      //"Harvest date": harvestDate,
      //"Expiry date": expiryDate,
      "units": units,
      "uid": _auth.currentUser.uid,
      "name": _nameController.text,
      "number": number,
      "user email": email,
      "shop": shopName,
      "latitude": latitude2,
      "longitude": longitude2,
      "address": address,
      //_addressController.text == null
      // ? CurrentAddress
      //: _addressController.text,
      'location': GeoPoint(this.latitudeData1, this.longitudeData1),
    });
  }

  //GeoPoint1(String latitude1, String Longitude1){
  //GeoPoint(latitude: latitude1, longitude: longitude1)
  //}
  double shoplatitude;
  double shoplongitude;

  handleSubmit() async {
    print(_auth.currentUser.uid);
    setState(() {
      isUploading = true;
      //return CircularProgressIndicator();
    });
    getCurrentLocation();
    //print("latitude::" +latitude1);
    //print("longitude::"+longitude1);
    await compressImage();
    String mediaUrl = await uploadImage(file);
    createPostInFirestore(
      firstName: _nameController.text,
      StartDate: StartDate,
      EndDate: EndDate,
      category: _myActivity,
      // subcategory: _subCategoryController.text,
      price: _unitController.text,
      mediaUrl: mediaUrl,
      latitude: "${latitude1}",
      longitude: "${longitude1}",
      address: _addressController.text.isNotEmpty ?   _addressController.text
          : CurrentAddress,
      //location: GeoPoint(double.parse(latitude1), double.parse(longitude1)),

      //harvestDate: startDate.toString(),
      //expiryDate: expiryDate.toString(),
    );
    _nameController.clear();
    _categoryController.clear();
    //_subCategoryController.clear();
    _unitController.clear();
    setState(() {
      file = null;
      isUploading = false;
    });
    return showDialog(
        context: context,
        builder: (BuildContext contxt) {
          return AlertDialog(
            title: Text("Success"),
            content: Text("Posted Successfully"),
            actions: [
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  //Navigator.push(context,MaterialPageRoute(builder: (context) => PostWizardStep1()));
                  //Navigator.of(context).pop();
                },
              )
            ],
          );
        });
    /*Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: ((context) => HomePage())));*/
    setState(() {
      file = null;
      isUploading = false;
    });
  }

  String StartDate, EndDate;

  var units1;

  List<DropdownMenuItem<String>> menuItems1 = List();

  final GlobalKey<FormFieldState> _vegetablekey = GlobalKey();

  double latitude1, longitude1;
  String placeName1;
  String shopAddress1;

  double longitudeData1;
  double latitudeData1;
  double latitudeData;
  double longitudeData;
  String _currentAddress;
  String CurrentAddress = " ";

  Position currentLocation;

  getCurrentLocation() async {
    final geoPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
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

  String _myActivity;
  String _myActivityResult;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
    _categoryController.text.isEmpty;
    _nameController.text.isEmpty;
    _unitController.text.isEmpty;
    setState(() {
      file = null;
      isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _fetch();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        /*leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: ((context) => Home()))),
        ),*/
        backgroundColor: Colors.yellow[100],
        title: Text(
          'Post',
          style: TextStyle(color: Colors.orange[900]),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.yellow[300],
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                imageProfile(),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please add food items name';
                          } else
                            return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Name of the food',
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
                        //initialValue: DateTime.now().toString(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        icon: Icon(Icons.event),
                        dateLabelText: 'Start Date',
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
                        //initialValue:
                          //  DateTime.now().add(Duration(days: 3)).toString(),
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
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ListTile(
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
                      SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        maxLines: 6,
                        controller: _addressController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Press the navigation button';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            /*suffixIcon:IconButton(
                            icon:  Icon(Icons.location_on),
                            onPressed: (){
                              getCurrentLocation();
                              //return CurrentAddress;
                              },
                          ),*/
                            hintText: CurrentAddress,
                            labelText: CurrentAddress,
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      // SizedBox(height: 30),
                      SizedBox(height: 30),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _unitController,
                        decoration: InputDecoration(
                            labelText: 'enter Price',
                            labelStyle: TextStyle(color: Colors.black),
                            //hintText: 'enter number',
                            suffixIcon: DropdownButton<String>(
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
                        height: 30,
                      ),
                      //buildHarvestDate(context),
                      //buildExpiryDate(context),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed:
                                isUploading ? null : () => handleSubmit(),
                            child: Center(
                                child: Text(
                              'Submit',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            )),
                          ),
                          /*GestureDetector(
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.green[400],
                                  ),
                                ),
                                width: 100.0,
                                height: 40,
                                child: Center(
                                    child: Text(
                                  'Submit',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ))),
                            onTap: isUploading ? null : () => handleSubmit(),
                            //color: Colors.white,
                          ),*/
                          /* GestureDetector(
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.green[400],
                                  ),
                                ),
                                width: 100.0,
                                height: 40,
                                child: Center(
                                    child: Text('Cancel',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)))),
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: ((context) => HomePage())));
                            },
                            // color: Colors.white,
                          )*/
                        ],
                      ),
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

  Widget imageProfile() {
    return Stack(
      children: <Widget>[
        CircleAvatar(
          radius: 80.0,
          backgroundImage: file == null
              ? AssetImage('images/pic1.jpeg')
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
            'Provide Food Image',
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
                  //handleTakePhoto();
                  getImageFromCamera();
                },
                icon: Icon(Icons.camera),
                label: Text('Camera'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  File file;
  final picker = ImagePicker();

  Future getImageFromCamera() async {
    final pickedImage = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedImage != null) {
        file = File(pickedImage.path);
      } else {
        print("no images");
      }
    });
  }

  handleTakePhoto() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 675, maxWidth: 960);
    setState(() {
      this.file = file;
    });
  }
}
