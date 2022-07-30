import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../screens/add_post_screen.dart';
import '../screens/feed_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/search_screen.dart';
import '../utils/colors.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  int _page = 0;

  late PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  void navigate(int value) {
    _pageController.jumpToPage(value);
    setState(() {
      _page = value;
    });

    print(_page);
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: SvgPicture.asset(
            "assets/ic_instagram.svg",
            color: primaryColor,
            height: 32,
          ),
          actions: [
            IconButton(
                onPressed: () => navigate(0),
                icon: Icon(
                  Icons.home,
                  color: _page == 0 ? primaryColor : secondaryColor,
                )),
            IconButton(
                onPressed: () => navigate(1),
                icon: Icon(
                  Icons.search,
                  color: _page == 1 ? primaryColor : secondaryColor,
                )),
            IconButton(
                onPressed: () => navigate(2),
                icon: Icon(
                  Icons.favorite,
                  color: _page == 2 ? primaryColor : secondaryColor,
                )),
            IconButton(
                onPressed: () => navigate(3),
                icon: Icon(
                  Icons.person,
                  color: _page == 3 ? primaryColor : secondaryColor,
                )),
            IconButton(
                onPressed: () => navigate(4),
                icon: Icon(
                  Icons.message_outlined,
                  color: _page == 4 ? primaryColor : secondaryColor,
                ))
          ],
        ),
        body: PageView(
          children: [
            FeedScreen(),
            SearchScreen(),
            Text("likes"),
            AddPostScreen(),
            ProfileScreen(uid: user!.uid)
          ],
          controller: _pageController,
          onPageChanged: (val) {
            setState(() {
              _page = val;
            });
          },
        ));
  }
}
