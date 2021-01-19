import 'package:flutter/material.dart';
import 'auth.dart';

import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Sign in to Brew Crew'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: RaisedButton(
          child: Text('sign in anon'),
          onPressed: () async {
            dynamic result = await _auth.signInAnon();
            if(result == null){
              print('error signing in');
            } else {
              print('signed in');
              print(result.uid);
            }
          },
        ),
      ),
    );
  }
}