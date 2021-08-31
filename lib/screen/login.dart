import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gharelu/config/palette.dart';
import 'package:gharelu/screen/Home.dart';
import 'package:gharelu/screen/homePage.dart';
import 'package:gharelu/screen/signUpOrLogin.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {


  String username , email, password;
  bool isVisible = true;

  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final auth = FirebaseAuth.instance;

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();


  void signIn() {
    auth
        .signInWithEmailAndPassword(
        email: emailController.text, password: passwordController.text)
        .then((_) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: ((context) => HomePage())));
    }).catchError((err) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(err.message),
              actions: [
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
  }

  bool validateAndSave() {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      print('Form is valid');
      form.save();
      return true;
    } else {
      print('Form is invalid');
      return false;
    }
  }

  @override
  void initState() {
    emailController.clear();
    passwordController.clear();
    super.initState();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.yellow[100],
        title: Text('Login',style: TextStyle(color: Colors.orange[900]),),
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
              SizedBox(height: 50,),
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
                key: formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 70,),
                    SizedBox(height: 30,),
                    Container(
                      width: 350,
                      child: TextFormField(
                        controller: emailController,
                        onSaved: (val) => email = val,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Email Address",
                          labelStyle: TextStyle(fontSize: 15.0),
                          hintText: "Must be at least 3 characters",
                        ),
                      ),
                    ),
                    SizedBox(height: 30,),
                    Container(
                      width: 350,
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: isVisible,
                        onSaved: (val) => password = val,
                        decoration: InputDecoration(
                          suffix: GestureDetector (
                            child: Text(isVisible ? 'Show' : 'Hide'),
                            onTap: (){
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
                    SizedBox(height: 80,),
                    ButtonTheme(
                      minWidth: 200.0,
                      height: 50.0,
                      child: GestureDetector(
                        //color: Colors.green[400],
                        onTap: (){
                         signIn();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.orange[50]),
                              color: Colors.orange[500]),
                          width: 300,
                          height: 50,
                          child: Center(
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
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
