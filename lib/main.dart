import 'package:flutter/material.dart';
import 'package:mobilsle_notes_clone/screens/authentication/authenticate.dart';
import 'screens/authentication/authenticate.dart';
import 'screens/root.dart';
void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Required for implementation of StatelessWidget
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Root(auth: Auth())
    );
  }
}
