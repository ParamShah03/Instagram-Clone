import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta/providers/user_provider.dart';
import 'package:insta/utils/colors.dart';
import 'package:insta/utils/global_variables.dart';
import 'package:provider/provider.dart';
import 'package:insta/models/user.dart' as model;

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  String usrname = '';
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    getUserName();
    pageController = PageController();
  }
  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }
  void getUserName() async {
    DocumentSnapshot snap= await FirebaseFirestore.instance.collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
    .get();

    setState(() {
      usrname = (snap.data() as Map<String, dynamic>)['username'];
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }


  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    return Center(
      child: Scaffold(
        bottomNavigationBar: CupertinoTabBar(
          backgroundColor: mobileBackgroundColor,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home, color: _page==0? primaryColor: secondaryColor,),
                label: '', backgroundColor: primaryColor
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.search, color: _page==1? primaryColor: secondaryColor),
                label: '', backgroundColor: primaryColor
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_circle, color: _page==2? primaryColor: secondaryColor),
                label: '', backgroundColor: primaryColor
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite, color: _page==3? primaryColor: secondaryColor),
                label: '', backgroundColor: primaryColor
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person, color: _page==4? primaryColor: secondaryColor),
                label: '', backgroundColor: primaryColor
            ),
          ],
          onTap: navigationTapped,
        ),
        body: PageView(
          children: homeScreenItems,
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: onPageChanged,
        ),
      ),
    );
  }
}
