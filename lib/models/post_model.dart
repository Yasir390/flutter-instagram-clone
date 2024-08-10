import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String description, uId, userName, postId;
  final String postUrl, profImage;
  final likes,dateToPublished;
  PostModel({
    required this.description,
    required this.postId,
    required this.dateToPublished,
    required this.likes,
    required this.postUrl,
    required this.profImage,
    required this.uId,
    required this.userName,
  });

  Map<String, dynamic> toJson() => {
        'description': description,
        'postId': postId,
        'uId': uId,
        'dateToPublished': dateToPublished,
        'likes': likes,
        'postUrl': postUrl,
        'profImage': profImage,
        'userName': userName,
      };

  static PostModel fromJson(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return PostModel(
      description: snapshot['description'] ?? '',
      postId: snapshot['postId'] ?? '',
      uId: snapshot['uId'] ?? '',
      dateToPublished: snapshot['dateToPublished'] ?? '',
      likes: snapshot['likes'] ?? '',
      postUrl: snapshot['postUrl'] ?? '',
      profImage: snapshot['profImage'] ?? '',
      userName: snapshot['userName'] ?? '',
    );
  }
}
