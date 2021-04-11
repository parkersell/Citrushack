
import 'package:cloud_functions/cloud_functions.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

class CloudFunction{
  Map<String, dynamic> map;
  Future<Map<String, dynamic>> getEmpathy(String arg, String arg2,String happyValue, String angryValue, String surpriseValue, String sadValue, String fearValue) async {
    int empathy = 0;
    try{
      final results = await FirebaseFunctions.instance.httpsCallable('function-3'
      ).call(<String, dynamic>{
        "prompt":arg,
        "response":arg2,
        "Happy":happyValue,
        "Angry":angryValue,
        "Surprise":surpriseValue,
        "Sad":sadValue,
        "Fear":fearValue,
      });

      //double empathy =  results.data;
      //List<dynamic> empathy = results.data;
      //print(empathy);

      map = new Map<String, dynamic>.from(results.data);
      empathy = map['score'];
      print(map);
      return map;
    }catch(error){
      print(error.toString());
    }
    return map;
  }


  final String arg,arg1;
  CloudFunction({this.arg,this.arg1});
  //FirebaseFunctions functions = FirebaseFunctions.instance;

  Future getResult() async{
    var url = '<FUNCTION_URL>';
    var httpClient = new HttpClient();
    String result;
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var json1 = await response.transform(utf8.decoder).join();
        var data = json.decode(json1);
        result = data['quote'] + "\n-- " + data['person'];
      } else {
        result =
        'Error getting cloud function:\nHttp status ${response.statusCode}';
      }
    }catch (exception) {
      result = 'Failed invoking cloudfunction';
    }
    // If the widget was removed from the tree while the message was in flight,
    // we want to discard the reply rather than calling setState to update our
    // non-existent appearance.
  }
}