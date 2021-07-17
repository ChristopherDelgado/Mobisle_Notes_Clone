import 'package:flutter/material.dart';

class Setting extends StatelessWidget {
  Setting({required this.signOut});
  final VoidCallback signOut;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,               // turns off the shadow
        title: Text('Mobisle Notes'),
        backgroundColor: Color.fromARGB(255, 101, 198, 0),
      // adding a leading button to the appbar - settings button
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Icon(Icons.arrow_back, size: 30,),
      ),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: Column(
          children: [ TextButton(
            child: Text('Sign Out',
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.red
              ),),
            onPressed: () {
              signOut();
              Navigator.pop(context);
            }
          ),
          ]
        ),
      ),);
  }

}