import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String username;
  final String uid;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profileImg;
  final likes;

  Post({
    required this.datePublished,
    required this.description,
    required this.likes,
    required this.postId,
    required this.postUrl,
    required this.profileImg,
    required this.uid,
    required this.username,
  });

  Map<String, dynamic> toJson() => {
        'description': description,
        'username': username,
        'uid': uid,
        'postId': postId,
        'datePublished': datePublished,
        'likes': likes,
        'postUrl': postUrl,
        'profileImg': profileImg,
      };

  Post fromSnap(DocumentSnapshot snapshot) {
    return Post(
        datePublished:
            (snapshot.data() as Map<String, dynamic>)['datePublished'],
        description: (snapshot.data() as Map<String, dynamic>)['description'],
        likes: (snapshot.data() as Map<String, dynamic>)['likes'],
        postId: (snapshot.data() as Map<String, dynamic>)['postId'],
        postUrl: (snapshot.data() as Map<String, dynamic>)['postUrl'],
        profileImg: (snapshot.data() as Map<String, dynamic>)['profileImg'],
        uid: (snapshot.data() as Map<String, dynamic>)['uid'],
        username: (snapshot.data() as Map<String, dynamic>)['username']);
  }
}
