import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';
import 'package:instagram_clone/screens/feed_screen.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/screens/search_screen.dart';
import 'package:instagram_clone/utils/colors.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayout();
}

class _MobileScreenLayout extends State<MobileScreenLayout> {
  //int currentIndex = 0;
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
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
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
      bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: false,
          showSelectedLabels: false,
          onTap: (index) {
            setState(() {
              navigationTo(index);
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: currentIndex == 0 ? Colors.white : Colors.grey,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search,
                  color: currentIndex == 1 ? Colors.white : Colors.grey),
              label: '',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline,
                    color: currentIndex == 2 ? Colors.white : Colors.grey),
                label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite,
                    color: currentIndex == 3 ? Colors.white : Colors.grey),
                label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.person,
                    color: currentIndex == 4 ? Colors.white : Colors.grey),
                label: ''),
          ]),
    );
  }
}
