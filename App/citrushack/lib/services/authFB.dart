import 'package:citrushack/services/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:citrushack/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AUser userFirebase(User user) {
    return user != null ? AUser(uid: user.uid) : null;
  }

  Stream<AUser> get user{
    return _auth.authStateChanges()
      .map(userFirebase);
  }
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      return null;
    }
  }

  Future registerAccount(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      //await DbService(uid: user.uid).updateUser("0", "0");
      return userFirebase(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future signInAccount(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future setData(String string1, String string2, String happyValue, String angryValue, String surpriseValue, String sadValue, String fearValue) async {
    try {
      final User userA = _auth.currentUser;
      final uidA = userA.uid;

      await DbService(uid: uidA).updateUser(string1, string2,happyValue, angryValue, surpriseValue, sadValue,fearValue);
      return userFirebase(userA);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future getData() async {
    /*
    try {
      final User userA = _auth.currentUser;
      final uidA = userA.uid;
      final CollectionReference data = FirebaseFirestore.instance.collection('data');
      final DocumentReference dat = data.doc(uidA);

      var name = snapshot['input'];
      print()
      //Stream<QuerySnapshot> snapshot = data.doc(uidA).collection('Entries').snapshots();
      print(snapshot);
      return userFirebase(userA);
    } catch (error) {
      print(error.toString());
      return null;
    }

     */
  }

}