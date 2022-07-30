import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instgram_clone/screens/profile_screen.dart';
import 'package:instgram_clone/utils/colors.dart';
import 'package:instgram_clone/utils/global_variables.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  bool isDone = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: _searchController,
          decoration: const InputDecoration(
            labelText: 'Search for a user',
          ),
          onFieldSubmitted: (String search) {
            setState(() {
              isDone = true;
            });
          },
        ),
      ),
      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('users')
              .where('username', isGreaterThanOrEqualTo: _searchController.text)
              .get(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return isDone
                  ? ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                    uid: snapshot.data!.docs[index]['uid'])));
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  snapshot.data!.docs[index]['photoUrl']),
                            ),
                            title: Text(snapshot.data!.docs[index]['username']),
                          ),
                        );
                      })
                  : FutureBuilder(
                      future:
                          FirebaseFirestore.instance.collection('posts').get(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return StaggeredGridView.countBuilder(
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              crossAxisCount: 3,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                print(index);
                                return Image.network(
                                    snapshot.data!.docs[index]['postUrl']);
                              },
                              staggeredTileBuilder: (index) {
                                return MediaQuery.of(context).size.width >
                                        webScreenWidth
                                    ? StaggeredTile.count(
                                        (index % 7 == 0) ? 1 : 1,
                                        (index % 7 == 0) ? 1 : 1)
                                    : StaggeredTile.count(
                                        (index % 7 == 0) ? 2 : 1,
                                        (index % 7 == 0) ? 2 : 1);
                              });
                        }
                      });
            }
          }),
    );
  }
}
