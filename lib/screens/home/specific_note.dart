import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobilsle_notes_clone/screens/authentication/authenticate.dart';

class SpecificNotes extends StatefulWidget {

  SpecificNotes({
    required this.auth,
    required this.title,
    required this.body,
    required this.folder});

  final BaseAuth auth;
  final String title;
  final String body;
  final String folder;

  @override
  State<StatefulWidget> createState() {
    return _SpecificNotesState();
  }

}

class _SpecificNotesState extends State<SpecificNotes> {

  User? user = FirebaseAuth.instance.currentUser;
  bool hasTitleUpdated = false;
  String title = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,               // turns off the shadow
        title: Text('${hasTitleUpdated ? title : widget.title}'),
        backgroundColor: Color.fromARGB(255, 101, 198, 0),
        // adding a leading button to the appbar - settings button
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, size: 30,),
        ),
      ),
      body: Container(
        // makes the container take the width and height of the device
        constraints: BoxConstraints.expand(),
        // sets children aligment to the middle of the horizontal axis
        alignment: Alignment(1,0),
        color: Colors.white,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                initialValue: '${hasTitleUpdated ? title : widget.title}',
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 10, right: 10, top: 10),

                ),
                onChanged: (text) {
                  print(hasTitleUpdated);
                  widget.auth.updateNotes(null, widget.folder, hasTitleUpdated ? title : widget.title, text);
                  setState(() {
                    hasTitleUpdated = true;
                  });
                  title = text;
                },
              ),
              TextFormField(
                initialValue: '${widget.body}',
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 10, right: 10, top: 10)
                ),
                onChanged: (text) => widget.auth.updateNotes(text, widget.folder, widget.title, null),
              ),
        ]
      ),
    ));
  }

}