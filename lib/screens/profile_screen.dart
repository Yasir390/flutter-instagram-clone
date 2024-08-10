import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/dimensions.dart';
import 'package:instagram_clone/widget/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLength = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  getData()async{
    try{
      log('get data called');
      setState(() {
        isLoading = true;
      });
    var userSnap =   await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();
    userData = userSnap.data()!;
   //followers,following length
   // followers = userSnap.get('followers').length;
    followers = userSnap.data()!['followers'].length;
    following = userSnap.data()!['following'].length;

    //isFollowing = userSnap.get('followers').contains(FirebaseAuth.instance.currentUser!.uid);
    isFollowing = userSnap.data()!['followers'].contains(FirebaseAuth.instance.currentUser!.uid);
    //get post length
    var postSnap = await FirebaseFirestore.instance.collection('posts').where('uId',isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
    postLength = postSnap.docs.length;

    if(mounted){
      setState(() {});
    }
      setState(() {
        isLoading = false;
      });
    }catch(e){
      setState(() {
        isLoading = false;
      });
      if(mounted){ // it means that the widget is currently active and part of the widget tree
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()),)) ;
      }
    }
  }
@override
  void initState() {
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar:width>webScreenSize?null: AppBar(
        backgroundColor: mobileBackgroundColor,
        title:  Text(userData['userName'] ?? ''),
      ),
      body:isLoading?const Center(
        child: CircularProgressIndicator(),)
          : Container(
        margin:EdgeInsets.symmetric(
            horizontal: width>webScreenSize? width*0.3:0 ), //

        child: ListView(
          children:  [
            Row(
              children: [
                 Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(userData['imgUrl'] ?? ''),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(userData['userName'] ?? ''),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildStatColumn(postLength, 'posts'),
                          buildStatColumn(followers, 'followers'),
                          buildStatColumn(following, 'following'),
                        ],
                      ),
                    ),
                      FirebaseAuth.instance.currentUser!.uid ==widget.uid?  FollowButton(
                      backgroundColor: mobileBackgroundColor,
                      borderColor: Colors.grey,
                      text: 'SignOut',
                      textColor: primaryColor,
                        onPressed: () async {
                       await FirestoreMethods().signOut().then((value) {
                         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>const LoginScreen() ,));
                       });
                      },
                    ): isFollowing?  FollowButton(
                        backgroundColor: Colors.white,
                        borderColor: Colors.grey,
                        text: 'Unfollow',
                        textColor: Colors.black,
                        onPressed: () async{
                          log('print from Unfollow btn: ${userData['uId']}');
                          await FirestoreMethods().followUser(uid: FirebaseAuth.instance.currentUser!.uid, followId: userData['uId']);

                          setState(() {
                            isFollowing = false;
                            followers--;
                          });
                        },
                      ) :

                      FollowButton(
                        backgroundColor: Colors.blue,
                        borderColor: Colors.blue,
                        text: 'Follow',
                        textColor: Colors.white,
                        onPressed: () async {
                          log('print from follow btn: ${userData['uId']}');
                          await FirestoreMethods().followUser(uid: FirebaseAuth.instance.currentUser!.uid, followId: userData['uId']);

                         setState(() {
                           isFollowing = true;
                           followers++;
                         });
                        },
                      )
                  ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(left: 18),
              child: Text(userData['bio'] ?? ''),
            ),
         //   Divider(),
            FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').where('uId',isEqualTo: widget.uid).get(),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator(),);
                }
                return GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,crossAxisSpacing: 5,mainAxisSpacing: 1.5,childAspectRatio: 1),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot snaps = snapshot.data!.docs[index];
                    return Image(image: NetworkImage( snaps['postUrl'] ),fit: BoxFit.cover,);
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }



  Column buildStatColumn(int num,String text){
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(num.toString(),style: const TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
        Text(text,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color: Colors.grey),),
      ],
    );
  }
}
