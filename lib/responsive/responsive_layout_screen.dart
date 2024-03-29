import 'package:flutter/material.dart';
import 'package:insta/providers/user_provider.dart';
import 'package:insta/responsive/web_screen_layout.dart';
import 'package:insta/utils/global_variables.dart';
import 'package:provider/provider.dart';

import 'mobile_screen_layout.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveLayout({
    Key? key,
    required this.webScreenLayout,
    required this.mobileScreenLayout
  }) : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    super.initState();
    addData();
  }
  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints){
          if(constraints.maxHeight > webScreenSize){
            return WebScreenLayout();
          }
          return MobileScreenLayout();
        }
    );
  }
}
