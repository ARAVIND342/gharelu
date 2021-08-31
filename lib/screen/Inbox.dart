import 'package:flutter/material.dart';
import 'package:gharelu/screen/messages.dart';
import 'package:gharelu/screen/notifications.dart';

class Inbox extends StatefulWidget {


  @override
  _InboxState createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Inbox'),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(child: Text('Messages'),),
                Tab(child: Text('Notifications'),),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              Messages(),
              Notifications(),
            ],
          ),
        ),
      ),
    );
  }
}