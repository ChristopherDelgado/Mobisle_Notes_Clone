import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobilsle_notes_clone/screens/authentication/authenticate.dart';
import 'package:mobilsle_notes_clone/screens/home/notes.dart';
import 'package:mobilsle_notes_clone/screens/setting/setting.dart';

class Home extends StatefulWidget {
  Home({required this.auth, required this.onSignedOut});

  final BaseAuth auth;
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  User? user = FirebaseAuth.instance.currentUser;

  List<String> titles = [
    'Title1',
    'Title2',
    'Hello?'
  ];

  @override
  Widget build(BuildContext context) {
    // Scaffold gives a base design and structure for our UI
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,               // turns off the shadow
          title: Text('Mobisle Notes'),
          backgroundColor: Color.fromARGB(255, 101, 198, 0),
          // adding a leading button to the appbar - settings button
          leading: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Setting(signOut: widget.onSignedOut,)));
            },
            child: Icon(Icons.settings),
          ),
          // adding buttons AKA actions to the appbar - create new folder button
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 15),
                child: GestureDetector(
                  onTap: () {
                    buildAlertDialogForNewFolder(context, 'folder');
                  },
                  child: Icon(Icons.create_new_folder, size: 30,),
                )
            )
          ],
        ),
        body: Container(
          // makes the container take the width and height of the device
          constraints: BoxConstraints.expand(),
          // sets children aligment to the middle of the horizontal axis
          alignment: Alignment(0,0),
          color: Color.fromARGB(255, 101, 198, 0),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('user').doc('${user!.uid}')
                .collection('folders').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(!snapshot.hasData) return const Text('Loading');
              return ListView.separated(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                  return ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Notes(
                            auth: Auth(),
                            title: snapshot.data!.docs[index].get('title'),)
                          )
                        );
                      },
                      title: Text(snapshot.data!.docs[index].get('title'),
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white
                      ),),
                    leading: Icon(Icons.folder, color: Colors.white,),
                    trailing: GestureDetector(
                      child: Icon(Icons.edit, color: Colors.white70),
                      onTap: () => buildAlertDialogEditFolder(
                          context,
                          snapshot.data!.docs[index].get('title')
                      ),
                    ),
                    );
                },
                separatorBuilder: (context, index) {
                  return Divider(color: Color.fromARGB(150, 255, 255, 255),);
                });
            }
            ),
          )
        );
  }

  Widget buildFolder(String title) {
    return Container(
        alignment: Alignment.centerLeft,
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Color.fromARGB(75, 255, 255, 255))
            )
        ),
        child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text('$title',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                  ),),
              ),
              SizedBox.expand(
                child: TextButton(
                  child: Text('',
                    style: TextStyle(color: Colors.white),),
                  onPressed: () => print('hi')
                  ,),
              ),
            ]
        )
    );
  }

  Future<dynamic> buildAlertDialogForNewFolder(BuildContext context, String title) {

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
                    widget.auth.addFolder(title);
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

  Future<dynamic> buildAlertDialogEditFolder(BuildContext context, String oldTitle) {

    TextEditingController editingController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('New $oldTitle name'),
            content: TextField(
              controller: editingController,
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  widget.auth.deleteFolder('$oldTitle');
                  Navigator.of(context).pop();
                },
                elevation: 5,
                child: Text('Delete',
                  style: TextStyle(
                      color: Colors.redAccent
                  ),
                ),
              ),
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
                    widget.auth.updateFolder(oldTitle, title);
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

