import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instgram_clone/screens/login_screen.dart';
import 'package:instgram_clone/services/auth_service.dart';
import 'package:instgram_clone/services/firestore_service.dart';
import 'package:instgram_clone/utils/colors.dart';
import 'package:instgram_clone/utils/utils.dart';
import 'package:instgram_clone/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  var postSnap;
  bool isFollowing = false;
  @override
  void initState() {
    getData();
    super.initState();
    getData();
  }

  getData() async {
    try {
      var snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      userData = snap.data()!;
      postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: userData['uid'])
          .get();
      isFollowing = userData['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      print(userData);
    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userData['username']),
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(userData['photoUrl']),
                            radius: 40,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildStatColumn(
                                        postSnap!.docs!.length, "Posts"),
                                    _buildStatColumn(
                                        userData['followers'].length,
                                        "Followers"),
                                    _buildStatColumn(
                                        userData['following'].length,
                                        "Following")
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? FollowButton(
                                            borderColor: Colors.grey,
                                            buttonColor: mobileBackgroundColor,
                                            function: () async {
                                              await AuthService().signOut();
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                return const LoginScreen();
                                              }));
                                            },
                                            text: 'Sign out',
                                            textColor: primaryColor)
                                        : isFollowing
                                            ? FollowButton(
                                                borderColor: Colors.grey,
                                                buttonColor: Colors.white,
                                                function: () async {
                                                  await FirestoreService()
                                                      .followUser(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          userData['uid']);
                                                  setState(() {
                                                    isFollowing = false;
                                                  });
                                                },
                                                text: 'Unfollow',
                                                textColor: Colors.black)
                                            : FollowButton(
                                                borderColor: Colors.blue,
                                                buttonColor: blueColor,
                                                function: () async {
                                                  await FirestoreService()
                                                      .followUser(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          userData['uid']);
                                                  setState(() {
                                                    isFollowing = true;
                                                  });
                                                },
                                                text: 'Follow',
                                                textColor: Colors.white)
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          userData['username'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 1),
                        child: Text(
                          userData['bio'],
                        ),
                      )
                    ],
                  ),
                ),
                Divider(
                  thickness: 2,
                ),
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .where('uid', isEqualTo: widget.uid)
                        .get(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return GridView.builder(
                          shrinkWrap: true,
                          itemCount: (snapshot.data!.docs as dynamic).length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 1,
                                  crossAxisSpacing: 3,
                                  mainAxisSpacing: 3),
                          itemBuilder: (context, index) {
                            DocumentSnapshot documentSnapshot =
                                (snapshot.data! as dynamic).docs[index];
                            return Container(
                                child: Image(
                              image: NetworkImage(
                                documentSnapshot['postUrl'],
                              ),
                              fit: BoxFit.cover,
                            ));
                          });
                    })
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

Column _buildStatColumn(int num, String label) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        num.toString(),
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      Container(
        margin: const EdgeInsets.only(top: 5),
        child: Text(
          label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
        ),
      )
    ],
  );
}
