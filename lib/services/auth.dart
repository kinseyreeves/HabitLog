import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

//TODO use this https://stackoverflow.com/questions/53194574/flutter-start-app-with-different-routes-depending-on-login-state to connect to firebase

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<bool> isLogged() async {
    try {
      final FirebaseUser user = await _firebaseAuth.currentUser();
     //bool isValidLogin = await Backendless.UserService.isValidLogin();
      print("CURRENT USER");
      print(user.uid);
      return user != null;
    } catch (e) {
      return false;
    }
  }


  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future signInAnon() async {
    /**
    Signs in the user anonymously, i.e. not with google
        and user data is kept in firebase
     */

    try {
      AuthResult result = await _firebaseAuth.signInAnonymously();
      FirebaseUser user = result.user;
      print(result.user);
      return user;
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}