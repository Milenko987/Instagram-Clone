import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instgram_clone/models/user.dart';
import 'package:instgram_clone/services/storage_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //sign up user

  Future<String> signupUser(
      {required String username,
      required String email,
      required String password,
      required String bio,
      required Uint8List? file}) async {
    String res = 'Some error occured';
    try {
      if (email.isNotEmpty &&
          username.isNotEmpty &&
          password.isNotEmpty &&
          bio.isNotEmpty &&
          file != null) {
        //register  user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String photoUrl =
            await StorageService().uploadImage("ProfilePics", file, false);

        UserModel user = UserModel(
            bio: bio,
            email: email,
            followers: [],
            following: [],
            photoUrl: photoUrl,
            uid: cred.user!.uid,
            userName: username);

        //add user to database
        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(user.toJson());
        //this approch will give random ID to users TABLE
        /* _firestore.collection("users").add({
          'username': username,
          'email': email,     
          'bio': bio,
          'uid': cred.user!.uid,
          'followers': [],
          'following': []
        });*/
        res = 'success';
      } else {
        res = 'Please fill all fields';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        res = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        res = 'The account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        res = 'Not a valid email address.';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> LoginUser(
      {required String email, required String password}) async {
    String res = 'An error occured';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        res = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        res = 'Wrong password provided for that user.';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<UserModel> getUserData() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return UserModel.fromSnap(snap);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
