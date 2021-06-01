import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/models/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';


//TODO use this https://stackoverflow.com/questions/53194574/flutter-start-app-with-different-routes-depending-on-login-state to connect to firebase

class AuthService {
  ///Service providing authentication

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();
  String firebaseUID;

  Future<String> checkUID() async {
    try {
      final FirebaseUser user = await _firebaseAuth.currentUser();
      this.firebaseUID = user.uid;
      return user.uid;
    } catch (e) {
      print("failed");
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      final FirebaseUser user = await _firebaseAuth.currentUser();

      print(user.uid);
      return true;
    } catch (e) {
      print("failed log in");
      return false;
    }
  }

  Future<FirebaseUser> getUser() async {
    try {
      final FirebaseUser user = await _firebaseAuth.currentUser();
      return user;
    } catch (e) {
      return null;
    }
  }

//  void setupDatabase() async{
//    try {
//      final FirebaseUser user = await _firebaseAuth.currentUser();
//
//    } catch (e) {
//      print("failed");
//      return false;
//    }
//  }
//
//  User userFromFirebaseUser(FirebaseUser user){
//    //get a user type from the firebase user
//
//    if(user!=null){
//      return Database().getLocalUser();
//    }
//    return null;
//  }

//  Stream<User> get user {
//    return _firebaseAuth.onAuthStateChanged
//        .map(userFromFirebaseUser);
//  }

  Future<void> signOut(BuildContext context) async {
//    Database().databaseDestructor();
    try{
      return await _firebaseAuth.signOut();

    }catch(e){
      print(e.toString());
      return null;
    }
  }

  signInGoogle() async{
    /**
     * Signs in with google
     */
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null){
      GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.getCredential(idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);
      AuthResult result = await _firebaseAuth.signInWithCredential(credential);
      //print("IS NEW USER?");
      FirebaseUser user = await _firebaseAuth.currentUser();
      print(result.additionalUserInfo.isNewUser);

      if(result.additionalUserInfo.isNewUser){
        print("NEW USER GOOGLE");
        Database().generateFirebaseUserInfo(user.uid);
      }
      await Database().setLocalUser(user.uid);

//      User dbUser = userFromFirebaseUser(user);
      return Database().getLocalUser();
    }
    return null;
  }

  Future signInAnon() async {
    /**
    Signs in the user anonymously, i.e. not with google
        and user data is kept in firebase
     */
    try {
      AuthResult result = await _firebaseAuth.signInAnonymously();

      FirebaseUser user = result.user;

      if(result.additionalUserInfo.isNewUser){
        print("IS NEW USER");
        Database().generateFirebaseUserInfo(user.uid);
      }

      Database().setLocalUser(user.uid);

      return Database().getLocalUser();

    }catch(e){
      print(e.toString());
      return null;
    }
  }
}




















