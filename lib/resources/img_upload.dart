import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../utils/firebase_const.dart';

class StorageMethods {
  Future<String> uploadImageToStorage(
      {required Uint8List? img,
      required String childName,
      bool isPost = false}) async {
    final User? user = authInstance.currentUser;
    final uId = user!.uid;

    // upload user image to storage
    Reference ref = FirebaseStorage.instance.ref().child(childName).child(uId);
    if(isPost){
      String id = const Uuid().v1();
     ref = ref.child(id);
    }
    await ref.putData(img!);
    String? imgUrl = await ref.getDownloadURL();
    return imgUrl;
  }
}
