import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gharelu/homePage/homeScreen.dart';
import 'package:provider/provider.dart';
import 'package:gharelu/screen/mapView.dart';
import 'package:gharelu/screen/Auth_provider.dart';
import 'package:gharelu/screen/signUpOrLogin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //Provider.debugCheckInvalidValueType = null;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'घरेलू App',
      //theme: ThemeData(
        //primarySwatch: Colors.blue,
      //),
      home: Container(child: signUpOrLogin()),
    );
  }
}

