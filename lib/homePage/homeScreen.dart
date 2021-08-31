import 'package:flutter/material.dart';
import 'package:gharelu/screen/Account.dart';
import 'package:gharelu/screen/Home.dart';
import 'package:gharelu/screen/Selling.dart';
import 'package:gharelu/screen/messages.dart';
import 'package:gharelu/screen/postWizardStep1.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>  {
  int _selectedIndex = 0;

  List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>()
  ];

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
        !await _navigatorKeys[_selectedIndex].currentState.maybePop();

        print(
            'isFirstRouteInCurrentTab: ' + isFirstRouteInCurrentTab.toString());

        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                //color: kGoodLightGray,
              ),
              title: Text('HOME'),
              activeIcon: Icon(
                Icons.person,
                //color: kGoodPurple,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                //color: kGoodLightGray,
              ),
              title: Text('CALENDAR'),
              activeIcon: Icon(
                Icons.person,
                //color: kGoodPurple,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                //color: kGoodLightGray,
                //size: 36,
              ),
              title: Text('PROFILE'),
              activeIcon: Icon(
                Icons.person,
                //color: kGoodPurple,
                //size: 36,
              ),
            ),
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
        body: Stack(
          children: [
            _buildOffstageNavigator(0),
            _buildOffstageNavigator(1),
            _buildOffstageNavigator(2),
          ],
        ),
      ),
    );
  }


  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        return [
          Home(),
          PostWizardStep1(),
          Account(),
        ].elementAt(index);
      },
    };
  }

  Widget _buildOffstageNavigator(int index) {
    var routeBuilders = _routeBuilders(context, index);

    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => routeBuilders[routeSettings.name](context),
          );
        },
      ),
    );
  }
}
