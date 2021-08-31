import 'package:flutter/material.dart';
import 'package:gharelu/config/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:gharelu/screen/Account.dart';
import 'package:gharelu/screen/Selling.dart';
import 'package:gharelu/screen/Inbox.dart';
import 'package:gharelu/screen/Home.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:gharelu/screen/messages.dart';
import 'package:gharelu/screen/postWizardStep1.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position _currentPosition;
  String _currentAddress;
  PageController pageController;

  int   pageIndex = 0;
  final List<Widget> _children = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    //createLog();
    //pageController = PageController();
    // print("inserting in firebase database using the ${currentUser.id}");

    // user = _store.get("currentUser");
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.jumpToPage(
      pageIndex,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  Widget build(BuildContext context) {
    //_getCurrentLocation();
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteCurrentTab = !await _navigatorKeys[pageIndex]
            .currentState.maybePop();
        return isFirstRouteCurrentTab;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: pageIndex,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          selectedLabelStyle: TextStyle(color: Colors.red),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.orange,
              activeIcon: Icon(Icons.home, color: Colors.red),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'Messages',
              backgroundColor: Colors.orange,
              activeIcon: Icon(Icons.message, color: Colors.red),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt),
              label: 'Post',
              backgroundColor: Colors.orange,
              activeIcon: Icon(Icons.camera_alt, color: Colors.red),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business_center_outlined),
              label: 'Selling',
              backgroundColor: Colors.orange,
              activeIcon: Icon(
                  Icons.business_center_outlined, color: Colors.red),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Account',
              backgroundColor: Colors.orange,
              activeIcon: Icon(Icons.account_circle, color: Colors.red),
              //tooltip: 'account'
            ),
          ],
          onTap: (index) {
            setState(() {
              pageIndex = index;
            });
          },
        ),
        body: Stack(
          children: [
            _buildOffstageNavigator(0),
            _buildOffstageNavigator(1),
            _buildOffstageNavigator(2),
            _buildOffstageNavigator(3),
            _buildOffstageNavigator(4),
          ],
        ),
        /*backgroundColor: Colors.white,
        body: PageView(
          children: <Widget>[
            //_getCurrentLocation(),
            /*if (_currentAddress != null) Text(
                _currentAddress
            ),
            FlatButton(
              child: Text("Get location"),
              onPressed: () {
                _getCurrentLocation();

              },
            ),*/
            Home(),
            Inbox(),
            PostWizardStep1(),
            Selling(),
            Account(),
            //auth: this.widget.auth,
            //logoutCallback: this.widget.logoutCallback,
            // profileId: _store.get('fbuid')),

          ],
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: CupertinoTabBar(
            currentIndex: pageIndex,
            onTap: onTap,
            activeColor: Colors.teal,
            items: [
              BottomNavigationBarItem(
                title: Text('Home',style: TextStyle(fontSize:12.5,fontWeight: FontWeight.bold),),
                icon: Icon(Icons.home),
              ),
              BottomNavigationBarItem(
                title: Text('Inbox',style: TextStyle(fontSize:12.5,fontWeight: FontWeight.bold),),
                icon: Icon(Icons.message),
              ),
              BottomNavigationBarItem(
                title: Text('Post',style: TextStyle(fontSize:12.5,fontWeight: FontWeight.bold),),
                icon: Icon(
                  Icons.camera_alt,
                  //size: 40.0,
                ),
              ),
              BottomNavigationBarItem(
                title: Text('Selling',style: TextStyle(fontSize:12.5,fontWeight: FontWeight.bold),),
                icon: Icon(Icons.business_center_outlined),

              ),
              BottomNavigationBarItem(
                title: Text('Account',style: TextStyle(fontSize:12.5,fontWeight: FontWeight.bold),),
                icon: Icon(Icons.account_circle),
              ),

            ]),*/
      ),
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        return [
          Home(),
          Messages(),
          PostWizardStep1(),
          Selling(),
          Account(),
        ].elementAt(index);
      },
    };
  }

  Widget _buildOffstageNavigator(int index) {
    var routeBuilders = _routeBuilders(context, index);

    return Offstage(
      offstage: pageIndex != index,
      child: Navigator(
        //key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => routeBuilders[routeSettings.name](context),
          );
        },
      ),
    );
  }


  _getCurrentLocation() {
    Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        //_currentPosition.latitude;
        //_currentPosition.longitude;
        _getAddressFromLatLng();
      });
      print(_currentPosition.latitude);
      print(_currentPosition.longitude);
      print(_currentPosition.floor);
      print(_currentPosition.accuracy);
      print(_currentPosition.altitude);
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude,
          _currentPosition.longitude
      );

      Placemark place = placemarks[0];

      setState(() {
        _currentAddress =
        "${place.locality}, ${place.postalCode}, ${place.country}";
      });

      print("_currentAddress" + _currentAddress);
    } catch (e) {
      print(e);
    }
  }
}

