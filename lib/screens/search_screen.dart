import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/utils/colors.dart';

import '../utils/dimensions.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
 final TextEditingController _searchController = TextEditingController();

 @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
 bool isShowUser = false;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
           backgroundColor: mobileBackgroundColor,
            centerTitle: true,
            title: Container(
              margin:EdgeInsets.symmetric(horizontal: width>webScreenSize? width*0.3:0 ), //
              child: SizedBox(
                height: kToolbarHeight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: TextFormField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search for a user',
                      border: OutlineInputBorder()
                    ),
                    onFieldSubmitted: (value) {
                      setState(() {
                        isShowUser = true;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          body:isShowUser? Container(
            margin:EdgeInsets.symmetric(horizontal: width>webScreenSize? width*0.3:0 ), //

            child: FutureBuilder(
              future: FirebaseFirestore.instance.collection('users').where('userName',isGreaterThanOrEqualTo:_searchController.text ).get(),
              builder: (context, snapshot) {
                if(!snapshot.hasData){
                return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(uid: snapshot.data!.docs[index]['uId']),));
                      },
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(snapshot.data!.docs[index]['imgUrl']),
                      ),
                      title: Text(snapshot.data!.docs[index]['userName']),
                    );
                  },
                );
              },
            ),
          ): Container(
            margin:EdgeInsets.symmetric(horizontal: width>webScreenSize? width*0.2:0 ), //
            child: FutureBuilder(
                future: FirebaseFirestore.instance.collection('posts').get(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData){
                    return const Center(child: CircularProgressIndicator(),);
                  }
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,

                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Image.network(snapshot.data!.docs[index]['postUrl']);
                    },

                  );
                },
            ),
          )
        ),
      ),
    );
  }
}
