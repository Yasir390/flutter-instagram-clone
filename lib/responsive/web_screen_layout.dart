import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/utils/colors.dart';

import '../screens/add_post_screen.dart';
import '../screens/feed_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/search_screen.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({super.key});

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {

  late PageController pageController;
  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void navigationTo(int index) {
    pageController.jumpToPage(index);
    setState(() {
      currentIndex = index;
    });
  }

  int currentIndex = 0;



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset('assets/images/logo/ic_instagram.svg',
          height: 40,
          colorFilter:  const ColorFilter.mode(
            Colors.white,
            BlendMode.srcIn,
          ),),
        actions: [
          IconButton(onPressed: () {
            navigationTo(0);
          }, icon:  Icon(Icons.home,color: currentIndex == 0 ?primaryColor:secondaryColor,)),
          IconButton(onPressed: () {
            navigationTo(1);
          }, icon:  Icon(Icons.search,color: currentIndex == 1 ?primaryColor:secondaryColor,)),
          IconButton(onPressed: () {
            navigationTo(2);
          }, icon:  Icon(Icons.add_circle_outline,color: currentIndex == 2 ?primaryColor:secondaryColor,)),
          IconButton(onPressed: () {
            navigationTo(3);
          }, icon:  Icon(Icons.favorite,color: currentIndex == 3 ?primaryColor:secondaryColor,)),
          IconButton(onPressed: () {
            navigationTo(4);
          }, icon:  Icon(Icons.person,color: currentIndex == 4 ?primaryColor:secondaryColor,)),
        ],
      ),
      body:  Center(
        child: PageView(
          controller: pageController,
          children:  [
            const FeedScreen(),
            const SearchScreen(),
            const AddPostScreen(),
            const Text('favorite'),
            ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid,),
          ],
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
