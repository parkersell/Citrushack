import 'package:flutter/material.dart';
import 'package:citrushack/services/authFB.dart';
import 'package:citrushack/services/db.dart';
import 'package:citrushack/services/functions.dart';


class Home extends StatelessWidget {
  String string1 = '';
  String string2 = '';
  final AuthService _auth = AuthService();
  final CloudFunction cloud = CloudFunction();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Generic Title'),
          backgroundColor: Colors.blue,
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('Logout'),
              onPressed: () async {
               await _auth.signOut();
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
              children: <Widget>[
                TextField(
                  obscureText: false,
                  onChanged: (val) {
                    string1 = val;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Prompt',
                  ),
                ),
                TextField(
                  obscureText: false,
                  onChanged: (val) {
                    string2 = val;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Response',
                  ),
                ),
                RaisedButton(
                  child: Text('Submit'),
                  onPressed: () {
                    print(string1);
                    print(string2);
                    AuthService().setData(string1,string2);
                    cloud.getEmpathy(string1,string2);
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top:95),
                ),

                RaisedButton(
                  child: Text('View History'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/second');
                  },
                ),
              ]
          ),
        ),
      ),
    );
  }
}


class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View History"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
          ]
        ),
      ),
    );
  }
}

