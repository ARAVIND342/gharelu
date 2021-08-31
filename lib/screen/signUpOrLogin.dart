import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gharelu/config/palette.dart';
import 'package:gharelu/screen/login.dart';
import 'package:gharelu/screen/signUp.dart';

class signUpOrLogin extends StatefulWidget {
  @override
  _signUpOrLoginState createState() => _signUpOrLoginState();
}

class _signUpOrLoginState extends State<signUpOrLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[100],
        title: Text('SignUp/Login',style: TextStyle(color: Colors.orange[900]),),
        centerTitle: true,
        /*actions: [
          FlatButton(
              onPressed: () {
                print('clicked');
              },
              child: Text('Cancel'))
        ],*/
      ),
      body: Stack(
        children: [
          Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage(Palette.pic8),
                  fit: BoxFit.cover,
                )),
                child: Container(
                  padding: EdgeInsets.only(top: 160, left: 15),
                  color: Colors.yellow.withOpacity(.15),
                  child: Padding(
                    padding: EdgeInsets.only(left: 5.0),
                    child: RichText(
                      text: TextSpan(
                        text: "घरेलू ",
                        style: TextStyle(
                          fontSize: 40.0,
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow[900],
                        ),
                        children: [
                          TextSpan(
                            text: "  Foods",
                            style: TextStyle(
                              fontSize: 35.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[900],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                /*child: Container(
                  padding: EdgeInsets.only(top: 120, left: 50),
                  color: Colors.green.withOpacity(.3),
                  child: Text(
                    'Vegetable Mandi',
                    style: TextStyle(
                      color: Colors.green[50],
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),*/
              )),
          Positioned(
            top: 250,
            child: Container(
              height: 380,
              padding: EdgeInsets.all(30),
              width: MediaQuery.of(context).size.width - 40,
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.yellow[50],
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 5,
                    )
                  ]),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 40,),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Container(
                      height: 60,
                      width: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        shape: BoxShape.rectangle,
                        color: Colors.yellow[700],
                      ),
                      child: TextButton(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 27,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => SignUp()));
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Container(
                      height: 60,
                      width: 400,
                      decoration: BoxDecoration(
                        //borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.yellow[700],
                          width: 5.0,
                        ),
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        // color: Colors.green,
                      ),
                      child: TextButton(
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 27,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => Login()));
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child:Center(
                      child: Text(
                        '1.1', 
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ) ,
                  )
                ],
              ),
            ),
          )
          /* Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Center(
                  child: Text(
                    'Vegetable Mandi',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  ),
                ),
                SizedBox(
                  height: 90,
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Container(
                          height: 70,
                          width: 400,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.green,
                          ),
                          child: TextButton(
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              print('clicked');
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Container(
                          height: 70,
                          width: 400,
                          decoration: BoxDecoration(
                            //borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.green,
                              width: 5.0,
                            ),
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            // color: Colors.green,
                          ),
                          child: TextButton(
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              print('clicked');
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),*/
        ],
      ),
    );
  }
}
