import 'package:flutter/material.dart';
import 'package:instgram_clone/providers/user_provider.dart';
import 'package:instgram_clone/responsive/web_screen_layout.dart';
import 'package:instgram_clone/utils/global_variables.dart';
import 'package:provider/provider.dart';

import 'mobile_screen_layout.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveLayout(
      {Key? key,
      required this.mobileScreenLayout,
      required this.webScreenLayout})
      : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<UserProvider>(context, listen: false).refreshUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth > webScreenWidth) {
              return widget.webScreenLayout;
            } else {
              return widget.mobileScreenLayout;
            }
          });
        });
  }
}
