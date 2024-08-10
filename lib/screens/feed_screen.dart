import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/services/global_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/dimensions.dart';
import 'package:instagram_clone/widget/post_card.dart';

import '../services/flutter_toast.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: width>webScreenSize?null: AppBar(
        backgroundColor:  width>webScreenSize?webBackgroundColor:mobileBackgroundColor ,
        centerTitle: false,
        title: SvgPicture.asset('assets/images/logo/ic_instagram.svg',
          height: 40,
          colorFilter:  const ColorFilter.mode(
            Colors.white,
            BlendMode.srcIn,
          ),),
        actions: [
          IconButton(onPressed: () {

          }, icon: const Icon(Icons.message_outlined))
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('posts').snapshots(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: SpinKitFadingCube(color: Colors.black,),);
            }

          return  ListView.builder(
              itemCount:snapshot.data!.docs.length ,
                itemBuilder: (context, index) {
                  return  Container(
                    margin: EdgeInsets.symmetric(horizontal: width>webScreenSize?width*0.3:0,vertical: width>webScreenSize?15:0 ),
                    child: PostCard(
                      snap: snapshot.data!.docs[index].data(),
                    ),
                  );
                },
            );
          },
        ));
  }
}
