import 'package:flutter/material.dart';
import 'package:citrushack/services/authFB.dart';
import 'package:citrushack/services/db.dart';
import 'package:citrushack/services/functions.dart';
import 'package:flutter/services.dart';
String string1 = '';
String string2 = '';
int result=0;
String advice=' ';
final AuthService _auth = AuthService();
final CloudFunction cloud = CloudFunction();
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Empath'),
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
          child: Column(children: <Widget>[
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
                AuthService().getData();
                Navigator.pushNamed(context, '/second');
              },
            ),
          ]),
        ),
      ),
    );
  }
}

String numberValidator(String value) {
  if(value == null) {
    return null;
  }
  final n = num.tryParse(value);
  if(n > 5 || n > 0) {
    return '"$value" is not a valid number';
  }
  return null;
}

class SecondRoute extends StatelessWidget {
  @override
  String happyValue = '2';
  String angryValue = '2';
  String supriseValue = '2';
  String sadValue = '2';
  String fearValue = '2';
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Self-Reflection"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(children: <Widget>[
            TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: numberValidator,
                decoration: InputDecoration(
                    labelText:"Happy value",
                    hintText: "Enter a number 1-5",
                ),
                onChanged: (val) {
                happyValue = val;
                },
            ),
          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: numberValidator,
            decoration: InputDecoration(
              labelText:"Angry value",
              hintText: "Enter a number 1-5",
            ),
            onChanged: (val) {
              angryValue = val;
            },
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: numberValidator,
            decoration: InputDecoration(
              labelText:"Suprise value",
              hintText: "Enter a number 1-5",
            ),
            onChanged: (val) {
              angryValue = val;
            },
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: numberValidator,
            decoration: InputDecoration(
              labelText:"Sad value",
              hintText: "Enter a number 1-5",
            ),
            onChanged: (val) {
              sadValue = val;
            },
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: numberValidator,
            decoration: InputDecoration(
              labelText:"Fear value",
              hintText: "Enter a number 1-5",
            ),
            onChanged: (val) {
              fearValue = val;
            },
          ),
          RaisedButton(
            child: Text('Submit'),
            onPressed: () {
              print(string1);
              print(string2);
              result = 0;
              AuthService().setData(string1, string2, happyValue, angryValue, supriseValue, sadValue, fearValue);
              cloud.getEmpathy(string1, string2, happyValue, angryValue, supriseValue, sadValue, fearValue).then((value)=>{
                result = value['score'],
                advice = value['advice']
              });
              print(result);
              Future.delayed(Duration(milliseconds: 9000), () {
                Navigator.pushNamed(context, '/third');
              });

            },
          ),
        ]),
      ),
    );
  }
}
void delay() async{
  while(result == 0){
  }
}

class ThirdRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Result"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 150),
              ),
              Text(
                'Your empathy is $result\n\nSome advice:\n $advice',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ]
        ),
      ),
    );
  }
}
