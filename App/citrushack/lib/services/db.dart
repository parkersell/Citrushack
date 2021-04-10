import 'package:cloud_firestore/cloud_firestore.dart';

class DbService{


  final String uid;
  DbService({this.uid});
  final CollectionReference empathyData = FirebaseFirestore.instance.collection('data');

  Future updateUser(String input, String response) async{
    int time = DateTime.now().millisecondsSinceEpoch;
    String sec = time.toString();
    return await empathyData.doc(uid).collection('Entries').doc(sec).set({
      'input': input,
      'response': response,
    });
  }

}

