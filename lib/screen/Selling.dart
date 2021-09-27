import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as Im;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:gharelu/screen/homePage.dart';
import 'package:gharelu/screen/updateDetails.dart';
import 'package:gharelu/screen/viewMore.dart';

class Selling extends StatefulWidget {
  @override
  _SellingState createState() => _SellingState();
}

class _SellingState extends State<Selling> {
  final _key = GlobalKey<FormState>();
  TextEditingController _unitController = new TextEditingController();
  TextEditingController _itemController = new TextEditingController();

  var units;

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
        print("email is" + email);
        print(uid);
        print(number);
        print(latitude2);
        print(longitude2);
        print(shopName);

        /*print("seller is  " + widget.sellerName);
        print("seller is  " + widget.price);
        print("seller is  " + widget.number1);
        print("seller is  " + widget.shopName1);
        print("seller is  " + widget.pic);
        print("seller is  " + widget.startDate);
        print("seller is  " + widget.endDate);
        print("seller is  " + widget.postId);*/
        //print(units);
      }).catchError((e) {
        print(e);
      });

    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore
        .collection("Selling details")
        .where('uid', isEqualTo: uid)
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

  final CollectionReference userRef =
      FirebaseFirestore.instance.collection('Selling details');

  Widget imageProfile() {
    return Stack(
      children: <Widget>[
        CircleAvatar(
          radius: 80.0,
          backgroundImage: file == null
              ? AssetImage('images/pic3.jpg')
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
              TextButton.icon(
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

  @override
  Widget build(BuildContext context) {
    //_fetch();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[100],
        title: Text(
          'Update Product Details',
          style: TextStyle(color: Colors.orange[900]),
        ),
        centerTitle: true,
        /*leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: ((context) => Selling())));
          },
        ),*/
      ),
      // backgroundColor: Colors.green[200],
      body: Container(
        child: FutureBuilder(
          future: _fetch(),
          builder: (_, snapshot) {
            if (snapshot.connectionState != ConnectionState.done)
              return Center(
                child: CircularProgressIndicator(),
              );
            return ListView.builder(
                itemCount: snapshot.data != null ? snapshot.data.length : null,
                itemBuilder: (_, index) {
                  DocumentSnapshot data =
                      snapshot.data != null ? snapshot.data[index] : null;
                  return Container(
                    height: 130,
                    child: Card(
                      child: Column(
                        children: [
                          ListTile(
                            leading: Container(
                              width: 70.0,
                              height: 70.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                //border: Border.all(
                                //color: Colors.red[500],
                                //),
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(data['image']) == null
                                      ? AssetImage('images/pic3.jpg')
                                      : NetworkImage(data['image']),
                                ),
                              ),
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data["Category"],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0),
                                      ),
                                      Row(
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

                                      //Text(data['Student uid']),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  //crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    //if (data['uid'] == uid)
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 16.0),
                                      child: RaisedButton(
                                          onPressed: () {
                                            print('clicked');
                                            Navigator.push(context,MaterialPageRoute(builder: (context) => UpdateDetails(data['Name'] != null
                                                  ? data['Name']
                                                  : " ",
                                                data["Price"] != null
                                                    ? data["Price"]
                                                    : " ",
                                                data["units"] != null ? data["units"] : " ",
                                                "${data['number']}" != null
                                                    ?  "${data['number']}"
                                                    : " ",
                                               // data['shop'] == null
                                                 //   ? " "
                                                   // : data['shop'],
                                                data['image'] == null
                                                    ? " "
                                                    : data['image'],
                                                data['Start Date'] == null ? " ": data['Start Date'],
                                                data['End Date'] == null ? " ": data['End Date'],
                                                data['postId'] == null ? " ": data['postId'],
                                                data['Category'] == null ? " ": data['Category'],
                                                //data['SubCategory'] == null ? " ": data['SubCategory'],
                                              )));
                                          },
                                          child: Text('update')),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}
