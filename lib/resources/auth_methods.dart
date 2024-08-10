import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/utils/firebase_const.dart';

class AuthMethods{

  Future<UserModel> getUserDetails()async{
     User? user = authInstance.currentUser;
     String uId = user!.uid;

     DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uId).get();

     return UserModel.fromJson(userDoc);
  }

}