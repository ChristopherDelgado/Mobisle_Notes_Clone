import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobilsle_notes_clone/screens/authentication/authenticate.dart';
import 'authentication/login.dart';
import 'home/home.dart';
class Root extends StatefulWidget {
  Root({required this.auth});
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => _RootState();

}

enum AuthStatus {
  notSignedIn,
  signedIn
}

class _RootState extends State<Root> {

  AuthStatus _authStatus = AuthStatus.notSignedIn;

  @override
  void initState() {

    super.initState();
    // we wait until Firebase is ready then we check if a user is logged in
    Firebase.initializeApp().whenComplete(() {
      User? user = widget.auth.currentUser();
      setState(() {
        _authStatus = user == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

  void _signedIn() {
    setState(() {
      _authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut() {
    setState(() {
      _authStatus = AuthStatus.notSignedIn;
    });
  }
  @override
  Widget build(BuildContext context) {
    switch(_authStatus) {
      case AuthStatus.notSignedIn:
        return Login(
          auth: Auth(),
          onSignedIn: _signedIn
        );
      case AuthStatus.signedIn:
        return Home(
          auth: Auth(),
          onSignedOut: _signedOut
        );
    }
  }

}