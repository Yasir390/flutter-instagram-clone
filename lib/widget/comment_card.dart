import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({Key? key,required this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currUser = userProvider.getUser;
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 16,
      ),
      child:Row(
        children: [
             CircleAvatar(
            backgroundImage: NetworkImage(
               widget.snap['profilePic']),
            radius: 18,
          ),
          Expanded(
            child: Padding(padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RichText(text:  TextSpan(
                  children:[
                    TextSpan(
                      text: "${widget.snap['name']} ",
                      style: const TextStyle(fontWeight: FontWeight.bold)
                    ),
                    TextSpan(
                      text: widget.snap['text'],
                    ),
                  ]
                ),
                ),
                  Padding(padding:const EdgeInsets.only(top: 4),
                child: Text(
                  DateFormat.yMMMd().format(
                      widget.snap['datePublished'].toDate()
                  ),
                    style: const TextStyle(fontWeight: FontWeight.bold)
                ),
                )
              ],
            ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.favorite,size: 18,),

          )
        ],
      ),
    );
  }
}
