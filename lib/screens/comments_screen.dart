import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/widget/comment_card.dart';
import 'package:provider/provider.dart';

import '../provider/user_provider.dart';

class CommentsScreen extends StatefulWidget {
  final snap;

  const CommentsScreen({super.key, required this.snap});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {

 final TextEditingController _commentController = TextEditingController();

 @override
  void dispose() {
   _commentController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currUser = userProvider.getUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        centerTitle: false,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('posts').doc(widget.snap['postId']).collection('comments').orderBy('datePublished',descending: true).snapshots(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(),);
            }
            return ListView.builder(
              itemCount:snapshot.data!.docs.length ,
              itemBuilder:(context, index) {
                return CommentCard(
                  snap: snapshot.data!.docs[index].data()
                );
              },
              );
          },
      ),

      bottomNavigationBar: SafeArea(
          child: Container(
        height: kToolbarHeight,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(currUser!.imgUrl),
              radius: 18,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                      hintText: 'Comment as ${currUser.userName}',
                      border: InputBorder.none),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                FirestoreMethods().postComment(
                  postId: widget.snap['postId'],
                  text: _commentController.text,
                  uId: currUser.uId,
                  name:currUser.userName,
                  profilePic: currUser.imgUrl,
                );
                if(_commentController.text.isNotEmpty){
                  _commentController.clear();
                }
              },
              child: const Text(
                'post',
                style: TextStyle(color: Colors.blue),
              ),
            )
          ],
        ),
      )),
    );
  }
}
