import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/resources/img_upload.dart';
import 'package:instagram_clone/services/flutter_toast.dart';
import 'package:uuid/uuid.dart';


class FirestoreMethods {
  Future<void> uploadPost(
      {required String description,
      required Uint8List img,
      required String uid,
      required String userName,
      required String profImage}) async {
    try {
      String photoUrl = await StorageMethods()
          .uploadImageToStorage(img: img, childName: 'posts', isPost: true);
      String postId = const Uuid().v1();

      PostModel postModel = PostModel(
        description: description,
        postId: postId,
        dateToPublished: DateTime.now(),
        likes: [],
        postUrl: photoUrl,
        profImage: profImage,
        uId: uid,
        userName: userName,
      );

      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .set(postModel.toJson());

    } catch (error) {
      toastMsg(msg: error.toString());
    }
  }

  Future<void> likePost({required String postId, required String uid, required List likes})async{
    try{
         if(likes.contains(uid)){
         await  FirebaseFirestore.instance
               .collection('posts')
               .doc(postId).update({
           'likes': FieldValue.arrayRemove([uid])
           });
         }
         else{
           await  FirebaseFirestore.instance
               .collection('posts')
               .doc(postId).update({
             'likes': FieldValue.arrayUnion([uid])
           });
         }
    }catch(e){
      toastMsg(msg: e.toString());
    }
  }

  Future<void> postComment({required String postId,required String text, required String uId,required String name, required String profilePic }) async {
    try{
      if(text.isNotEmpty){
        String commentId = const Uuid().v1();
        await FirebaseFirestore.instance.collection('posts').doc(postId).collection('comments').doc(commentId).set({
          'profilePic':profilePic,
          'name': name,
          'uid':uId,
          'text':text,
          'commentId':commentId,
          'datePublished':DateTime.now()
        });
      }else{
          toastMsg(msg: 'text empty');
      }
      
    }catch(error){
      toastMsg(msg: error.toString());
    }
  }

  Future<void> deletePost(String postId) async{
    try{
      await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
    }catch(e){
      toastMsg(msg: e.toString());
    }
  }

  Future<void> followUser({required String uid,required String followId})async{
    try{
      DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(uid).get();
        List following = (snap.data()! as dynamic)['following'];
        if(following.contains(followId)){
          await FirebaseFirestore.instance.collection('users').doc(followId).update({
            'followers': FieldValue.arrayRemove([uid])
          });
          await FirebaseFirestore.instance.collection('users').doc(uid).update({
            'following': FieldValue.arrayRemove([followId])
          });
        }
        else{
          await FirebaseFirestore.instance.collection('users').doc(followId).update({
            'followers': FieldValue.arrayUnion([uid])
          });
          await FirebaseFirestore.instance.collection('users').doc(uid).update({
            'following': FieldValue.arrayUnion([followId])
          });
        }

    }catch(e){
      toastMsg(msg: e.toString());
    }
  }

  Future<void> signOut()async{
    try{
      await FirebaseAuth.instance.signOut();
    }catch(e){
      toastMsg(msg: e.toString());
    }

  }
}

