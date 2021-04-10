import 'package:cloud_functions/cloud_functions.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

class CloudFunction{

  final String arg,arg1;
  String result = '';
  CloudFunction({this.arg,this.arg1});
  //FirebaseFunctions functions = FirebaseFunctions.instance;

  Future getResult() async{
    var url = '<FUNCTION_URL>';
    var httpClient = new HttpClient();

  }

  _getRandomQuote() async {


    String result;
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(UTF8.decoder).join();
        var data = JSON.decode(json);
        result = data['quote'] + "\n-- " + data['person'];
      } else {
        result =
        'Error getting a random quote:\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      result = 'Failed invoking the getRandomQuote function.';
    }

    // If the widget was removed from the tree while the message was in flight,
    // we want to discard the reply rather than calling setState to update our
    // non-existent appearance.
    if (!mounted) return;

    setState(() {
      _randomQuote = result;
    });
  }

}