import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  User? currentUser();
  void addFolder(String title);
  void addNotes(String title, String folder);
  void updateNotes(String? body, String folder, String oldTitle, String? newTitle);
  void updateFolder(String oldTitle, String newTitle);
  void deleteNote(String title, String folder);
  void deleteFolder(String title);
}

class Auth implements BaseAuth {
  // FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signInWithEmailAndPassword(String email, String password) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user!.uid;
  }

  Future<String> createUserWithEmailAndPassword(String email, String password) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    User? user = userCredential.user;
    DocumentReference docRef = FirebaseFirestore.instance
        .collection('user').doc('${user!.uid}');

    await docRef.collection('notes').add({
      'body' : 'Hello! Thank you for using my app!',
      'folder' : 'My Notes',
      'title': 'Introduction',
    });
    await docRef.collection('folders').add({
      'title' : 'My Notes'
    });
    return userCredential.user!.uid;
  }

  Future<void> signOut() async {
    FirebaseAuth.instance.signOut();
  }

  User? currentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    return user;
  }

  void addFolder(String title) async{
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('user').doc('${user.uid}')
          .collection('folders').add({
        'title': '$title'
      });
    }
  }

  void addNotes(String title, String folder) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('user').doc('${user.uid}')
          .collection('notes').add({
        'body' : '',
        'folder' : '$folder',
        'title': '$title',
      });
    }
  }

  void updateFolder(String oldTitle, String newTitle) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance.collection('user').doc('${user.uid}')
          .collection('folders').where('title', isEqualTo: '$oldTitle')
          .get().then((querySnapshot) {
            querySnapshot.docs.forEach((documentSnapshot) {
              documentSnapshot.reference.update({
                'title' : newTitle
              });
            });
      }
      );
      FirebaseFirestore.instance.collection('user').doc('${user.uid}')
          .collection('notes').where('folder', isEqualTo: '$oldTitle')
          .get().then((querySnapshot) {
        querySnapshot.docs.forEach((documentSnapshot) {
          documentSnapshot.reference.update({
            'folder' : newTitle
          });
        });
      }
      );
    }
  }

  void updateNotes(String? body, String folder, String oldTitle, String? newTitle) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance.collection('user').doc('${user.uid}')
          .collection('notes')
          .where('title', isEqualTo: '$oldTitle').where('folder', isEqualTo: '$folder')
          .get().then((querySnapshot) {
        querySnapshot.docs.forEach((documentSnapshot) {
          documentSnapshot.reference.update({
            'body' : body != null ? '$body' : documentSnapshot.get('body'),
            'folder' : '$folder',
            'title' : newTitle != null ? '$newTitle' : '$oldTitle'
          });
        });
      }
      );
    }
  }

  void deleteNote(String title, String folder) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance.collection('user').doc('${user.uid}')
          .collection('notes')
          .where('title', isEqualTo: '$title').where('folder', isEqualTo: '$folder')
          .get().then((querySnapshot) {
        querySnapshot.docs.forEach((documentSnapshot) {
          documentSnapshot.reference.delete();
        });
      }
      );
    }
  }

  void deleteFolder(String title) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance.collection('user').doc('${user.uid}')
          .collection('folders').where('title', isEqualTo: '$title')
          .get().then((querySnapshot) {
        querySnapshot.docs.forEach((documentSnapshot) {
          documentSnapshot.reference.delete();
        });
      }
      );
      FirebaseFirestore.instance.collection('user').doc('${user.uid}')
          .collection('notes').where('folder', isEqualTo: '$title')
          .get().then((querySnapshot) {
        querySnapshot.docs.forEach((documentSnapshot) {
          documentSnapshot.reference.delete();
        });
      }
      );
    }
  }
}