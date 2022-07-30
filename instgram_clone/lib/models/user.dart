import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String photoUrl;
  final String userName;
  final String bio;
  final List followers;
  final List following;

  UserModel(
      {required this.bio,
      required this.email,
      required this.followers,
      required this.following,
      required this.photoUrl,
      required this.uid,
      required this.userName});

  Map<String, dynamic> toJson() => {
        'username': userName,
        'uid': uid,
        'email': email,
        'photoUrl': photoUrl,
        'bio': bio,
        'followers': followers,
        'following': following
      };
  static UserModel fromSnap(DocumentSnapshot snapshot) {
    return UserModel(
        bio: (snapshot.data() as Map<String, dynamic>)['bio'],
        email: (snapshot.data() as Map<String, dynamic>)['email'],
        followers: (snapshot.data() as Map<String, dynamic>)['followers'],
        following: (snapshot.data() as Map<String, dynamic>)['following'],
        photoUrl: (snapshot.data() as Map<String, dynamic>)['photoUrl'],
        uid: (snapshot.data() as Map<String, dynamic>)['uid'],
        userName: (snapshot.data() as Map<String, dynamic>)['username']);
  }
}
