import 'package:citrushack/services/authFB.dart';
import 'package:flutter/material.dart';
import 'package:citrushack/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import'package:citrushack/models/user.dart';
import 'package:citrushack/screens/home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AUser>.value(
      value: AuthService().user,
      child:MaterialApp(

        routes: {
          '/': (context) => Wrapper(),
          '/second': (context) => SecondRoute(),
          '/third': (context) => ThirdRoute(),
        },
      ),
    );
  }
}

