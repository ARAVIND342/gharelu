import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gharelu/config/palette.dart';
import 'package:gharelu/screen/login.dart';
import 'package:gharelu/screen/signUpOrLogin.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailContoller = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _shopController = TextEditingController();

  final _firestore = FirebaseFirestore.instance;

  String username, email, password, number;
  bool isVisible = true;
  final _key = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String latitude1, longitude1;

  String lat1 , long1;

  getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    setState(() {
      latitude1 = "${position.latitude}";
      longitude1 ="${position.longitude}";
      print("latitude:  " + "${latitude1}");
      print("longitude: " + "${longitude1}");

      lat1 = position.latitude.toString();
      long1 = position.longitude.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    //getCurrentLocation();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.yellow[100],
        title: Text('Sign Up',style: TextStyle(color: Colors.orange[900]),),
        centerTitle: true,
        actions: [
          FlatButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: ((context) => signUpOrLogin())));
              },
              child: Text('Cancel'))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Center(
                child: Text(
                  'घरेलू Foods',
                  style: TextStyle(
                    fontSize: 40,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow[900],
                  ),
                ),
              ),
              Form(
                key: _key,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 70,
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
                        onSaved: (val) => username = val,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Name",
                          labelStyle: TextStyle(fontSize: 15.0),
                          hintText: "Must be at least 3 characters",
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
                        onSaved: (val) => username = val,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Shop Name",
                          labelStyle: TextStyle(fontSize: 15.0),
                          hintText: "Must be at least 3 characters",
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
                        onSaved: (val) => number = val,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Phone Number",
                          labelStyle: TextStyle(fontSize: 15.0),
                          hintText: "Must be at least 10 characters",
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
                            return 'Email cannot be empty';
                          } else
                            return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailContoller,
                        onSaved: (val) => email = val,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Email Address",
                          labelStyle: TextStyle(fontSize: 15.0),
                          hintText: "Must be at least 3 characters",
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
                            return 'Password cannot be empty';
                          } else
                            return null;
                        },
                        keyboardType: TextInputType.text,
                        controller: _passwordController,
                        obscureText: isVisible,
                        onSaved: (val) => password = val,
                        decoration: InputDecoration(
                          suffix: GestureDetector(
                            child: Text(isVisible ? 'Show' : 'Hide'),
                            onTap: () {
                              setState(() {
                                isVisible = !isVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(),
                          labelText: "Password",
                          labelStyle: TextStyle(fontSize: 15.0),
                          hintText: "Must be at least 3 characters",
                          //suffix: Text()
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Container(
                      width: 180.0,
                      height: 50,
                      //decoration: BoxDecoration(
                        //color: Colors.orange,
                      //),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.orange),
                        child: Center(
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        onPressed: () async {
                          getCurrentLocation();
                          //print("latitude::" + latitude1);
                          //print("longitude::" + longitude1);
                          //String mediaUrl = await uploadImage(file.path);
                          if (_key.currentState.validate()) {
                            FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: _emailContoller.text,
                                    password: _passwordController.text)
                                .then((signedInUser) {
                              String uid;
                              _firestore
                                  .collection('Users')
                                  .doc(signedInUser.user.uid)
                                  .set({
                                "Full name": _nameController.text,
                                "number": _numberController.text,
                                "email": _emailContoller.text,
                                "password": _passwordController.text,
                                "uid": _auth.currentUser.uid,
                                "latitude": latitude1,
                                "longitude": longitude1,
                                //"location": GeoPoint(double.parse(latitude1),double.parse(longitude1)),
                                "shop name": _shopController.text,
                              }).then((value) {
                                if (signedInUser != null) {
                                  return showDialog(
                                      context: context,
                                      builder: (BuildContext contxt) {
                                        return AlertDialog(
                                          title: Text("Success"),
                                          content: Text("Signed Up Successfully"),
                                          actions: [
                                            FlatButton(
                                              child: Text('OK'),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Login()));
                                              },
                                            )
                                          ],
                                        );
                                      });
                                }
                              }).catchError((e) {
                                print(e);
                              });
                            }).catchError((e) {
                              print(e);
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    /*ButtonTheme(
                      minWidth: 200.0,
                      height: 50.0,
                      child: RaisedButton(
                        color: Colors.green[400],
                         onPressed: () async {
                          getCurrentLocation();
                          print("latitude::" +latitude1);
                          print("longitude::"+longitude1);
                           //String mediaUrl = await uploadImage(file.path);
                           if(_key.currentState.validate()){
                           FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailContoller.text, password: _passwordController.text)
                               .then((signedInUser){
                             String uid;
                             _firestore.collection('Users').doc(signedInUser.user.uid)
                                 .set({
                               "Full name":_nameController.text,
                               "number":_numberController.text,
                               "email":_emailContoller.text,
                               "password":_passwordController.text,
                               "uid":_auth.currentUser.uid,
                               "latitude":latitude1,
                               "longitude":longitude1,
                               "shop name":_shopController.text,
                             }).then((value) {
                               if(signedInUser!=null){
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: ((context) => Login())));
                               }
                             }).catchError((e){
                               print(e);
                             });
                           }).catchError((e){
                             print(e);
                           });
                         }},
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                          ),
                        ),
                      ),
                    )*/
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
