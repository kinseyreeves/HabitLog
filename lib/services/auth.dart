import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/models/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/database.dart';


//TODO use this https://stackoverflow.com/questions/53194574/flutter-start-app-with-different-routes-depending-on-login-state to connect to firebase

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final googleSignIn = GoogleSignIn();
  String firebaseUID;

  Future<bool> isLogged() async {
    try {
      final FirebaseUser user = await _firebaseAuth.currentUser();
//      bool isValidLogin = await Backendless.UserService.isValidLogin();
//      print("CURRENT USER");
      this.firebaseUID = user.uid;
      return user != null;

    } catch (e) {
      print("failed");
      return false;
    }
  }


  Future<User> getUser() async {
    try {
      final FirebaseUser user = await _firebaseAuth.currentUser();
      //bool isValidLogin = await Backendless.UserService.isValidLogin();
      //print(user.uid);
      return userFromFirebaseUser(user);
    } catch (e) {
      return null;
    }
  }

  User userFromFirebaseUser(FirebaseUser user){
    //get a user type from the firebase user
    if(user!=null){
      Database().generateUserInfo(user.uid);
      return Database().getLocalUser();
    }
    return null;
  }

  Stream<User> get user {
    return _firebaseAuth.onAuthStateChanged
    //.map((FirebaseUser user) => _userFromFirebaseUser(user));
        .map(userFromFirebaseUser);
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
//      print("IS NEW USER?");
      FirebaseUser user = await _firebaseAuth.currentUser();
//      print(result.additionalUserInfo.isNewUser);
      if(result.additionalUserInfo.isNewUser){
        Database().createUserInfo(user.uid);
      }
      return userFromFirebaseUser(user);
    }
    return null;
  }

  Future<void> signOut() async {
    try{
      return await _firebaseAuth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future signInAnon() async {
    /**
    Signs in the user anonymously, i.e. not with google
        and user data is kept in firebase
     */
    try {
      AuthResult result = await _firebaseAuth.signInAnonymously();
//      print("IS NEW USER?");

      FirebaseUser user = result.user;
      if(result.additionalUserInfo.isNewUser){
        Database().createUserInfo(user.uid);
      }
      await Database().generateUserInfo(user.uid);

      return userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}