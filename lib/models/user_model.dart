import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserModel{
  final String email, uId, imgUrl, userName, bio;
  final List followers, following;

  UserModel({
    required this.email,
    required this.uId,
    required this.imgUrl,
    required this.userName,
    required this.bio,
    required this.followers,
    required this.following,
  });

  Map<String,dynamic> toJson()=>
      {
        'userName': userName,
        'email':email,
        'uId':uId,
        'imgUrl':imgUrl,
        'bio':bio,
        'followers':followers,
        'following':following
      };


  static UserModel fromJson(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
      email: snapshot['email'] ?? '',
      uId: snapshot['uId'] ?? '',
      imgUrl: snapshot['imgUrl'] ?? '',
      userName: snapshot['userName'] ?? '',
      bio: snapshot['bio'] ?? '',
      followers: List.from(snapshot['followers'] ?? []),
      following: List.from(snapshot['following'] ?? []),
    );
  }

}
