import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/services/flutter_toast.dart';
import 'package:instagram_clone/services/global.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:provider/provider.dart';
import '../provider/user_provider.dart';


class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool _isLoading = false;
  Uint8List? selectedImg;
 final _descriptionController = TextEditingController();
 @override
  void dispose() {
   _descriptionController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    await Provider.of<UserProvider>(context, listen: false).loadUserData();
  }

  Future<void> postImage(
      String uid,
      String userName,
      String profImage
      ) async {
   try{
     setState(() {
       _isLoading = true;
     });
        await FirestoreMethods().uploadPost(
        description: _descriptionController.text,
        img: selectedImg!,
        uid: uid,
        userName: userName,
        profImage: profImage,

      ).then((value) {
          setState(() {
            _isLoading = false;
          });
        toastMsg(msg: 'Post Uploaded');
          clearImg();
        });
   }catch(e){
     setState(() {
       _isLoading = false;
     });
        toastMsg(msg: e.toString());
   }
  }


 void clearImg(){
   setState(() {
     selectedImg = null;
   });
  }

  @override
  Widget build(BuildContext context) {


    return
      selectedImg==null?
    Center(
      child:   IconButton(onPressed: () {
        showImageDialog();
      }, icon: const Icon(Icons.upload)),
    )
    :
    Scaffold(
      appBar: AppBar(
        title:  const Text('Post to',style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),),
        leading: IconButton(
          onPressed: () {
            clearImg();
          },
          icon: const Icon(Icons.arrow_back,color: Colors.white,),
        ),
        actions:   [
          Consumer<UserProvider>(
            builder: (BuildContext context, userProvider, Widget? child) {
              return  TextButton(onPressed: () {
                postImage(userProvider.getUser!.uId, userProvider.getUser!.userName, userProvider.getUser!.imgUrl);
              }, child:  const Text('Post',style: TextStyle(
                  color: Colors.blue,
                  fontSize: 17
              ),));
            },

          ),
          const SizedBox(width: 13,)
        ],
        backgroundColor: mobileBackgroundColor,
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
      if (userProvider.isLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (userProvider.error.isNotEmpty) {
        return Center(child: Text("Error: ${userProvider.error}"));
      } else if (userProvider.getUser == null) {
        return const Center(child: Text("No user data available"));
      } else {
        return  Column(

            children: [
              _isLoading? const LinearProgressIndicator(color: Colors.blue,):const Padding(padding: EdgeInsets.only(top: 0),child: Divider(),),
              ListTile(
                leading:  CachedNetworkImage(
                  imageUrl: userProvider.getUser!.imgUrl,
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                    backgroundImage: imageProvider,
                  ),
                  placeholder: (context, url) => const CircularProgressIndicator(color: Colors.blue,),
                  errorWidget: (context, url, error) => CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    child: const Icon(Icons.error, color: Colors.red),
                  ),
                ),
                title:  TextField(
                  controller: _descriptionController,
                  minLines: 1,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Write a caption..',

                  ),
                ),
                trailing:SizedBox(
                  height: 50,
                  width: 50,
                  child: AspectRatio(aspectRatio: 487/451,child: Container(
                    decoration:  BoxDecoration(
                        image: DecorationImage(image: MemoryImage(selectedImg!),fit: BoxFit.fill,alignment: Alignment.topCenter)
                    ),
                  ),),
                ),
              ),

            ],
          );}
        },

      ),
    );


  }


  showImageDialog(){
return showDialog(context: context,
    builder: (context) {
      return SimpleDialog(
        title: const Center(child: Text('Select Image')),
        alignment: Alignment.center,

        children: [
          Center(
            child: SimpleDialogOption(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

              child: const Text('Select from camera'),
              onPressed: () async {

                Navigator.of(context).pop();
                Uint8List file = await pickImage(source: ImageSource.camera);
                setState(() {
                  selectedImg = file;
                });
              },
            ),
          ),
          Center(
            child: SimpleDialogOption(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

              child: const Text('Select from gallery'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(source: ImageSource.gallery);
                setState(() {
                  selectedImg = file;
                });
              },
            ),
          ),  Center(
            child: SimpleDialogOption(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

              child: const Text('Cancel'),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      );
    },);
  }

}
