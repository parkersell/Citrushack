import 'package:flutter/material.dart';
import 'package:citrushack/screens/auth/Auth.dart';
import 'package:provider/provider.dart';
import 'package:citrushack/models/user.dart';
import 'package:citrushack/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AUser>(context);

    if(user == null){
      return Auth();
    }
    else{
      return Home();
    }
  }
}

    