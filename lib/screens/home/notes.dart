import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobilsle_notes_clone/screens/authentication/authenticate.dart';
import 'package:mobilsle_notes_clone/screens/home/specific_note.dart';

class Notes extends StatefulWidget {

  Notes({required this.auth, required this.title});
  final BaseAuth auth;
  final String title;

  @override
  State<StatefulWidget> createState() {
    return _NotesState();
  }

}

class _NotesState extends State<Notes> {

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,               // turns off the shadow
          title: Text('${widget.title}'),
          backgroundColor: Color.fromARGB(255, 101, 198, 0),
          // adding a leading button to the appbar - settings button
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back, size: 30,),
          ),
          // adding buttons AKA actions to the appbar - create new folder button
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 15),
              child: GestureDetector(
                onTap: () => buildAlertDialog(context, 'Note'),
                child: Icon(Icons.add, size: 30,),
              )
            )
          ],
        ),
    body: Container(
      // makes the container take the width and height of the device
      constraints: BoxConstraints.expand(),
      // sets children aligment to the middle of the horizontal axis
      alignment: Alignment(0,0),
      color: Colors.white,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('user').doc('${user!.uid}')
              .collection('notes').where('folder', isEqualTo: widget.title).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if(!snapshot.hasData) return const Text('Loading');
            return ListView.separated(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            QueryDocumentSnapshot document = snapshot.data!.docs[index];
                            String title = document.get('title');
                            String body = document.get('body');
                            return SpecificNotes(auth: Auth(), title: title, body: body,folder: widget.title,);
                      }));
                    },
                    title: Text(snapshot.data!.docs[index].get('title'),
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black
                      ),),
                    trailing: GestureDetector(
                      child: Icon(Icons.delete, color: Colors.red,),
                      onTap: () => widget.auth.deleteNote(snapshot.data!.docs[index].get('title'), widget.title),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(color: Color.fromARGB(150, 101, 198, 0),);
                });
          }
      ),
    ),
    );
  }

  Future<dynamic> buildAlertDialog(BuildContext context, String title) {

    TextEditingController editingController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('New $title name'),
            content: TextField(
              controller: editingController,
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                elevation: 5,
                child: Text('Cancel',
                  style: TextStyle(
                      color: Colors.blueAccent
                  ),
                ),
              ),

              MaterialButton(
                onPressed: () {
                  String title = editingController.text.toString();
                  if (title.isNotEmpty) {
                    widget.auth.addNotes(title, widget.title);
                    Navigator.of(context).pop();
                  }
                },
                elevation: 5,
                child: Text('Done',
                  style: TextStyle(
                      color: Colors.blueAccent
                  ),
                ),
              )
            ],
          );
        });
  }

}