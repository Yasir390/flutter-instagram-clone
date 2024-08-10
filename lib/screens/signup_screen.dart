
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/resources/img_upload.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/services/flutter_toast.dart';
import 'package:instagram_clone/services/loading_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/firebase_const.dart';
import 'package:instagram_clone/widget/text_field_input.dart';

import '../services/global_methods.dart';
import '../utils/dimensions.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final  _userNameController = TextEditingController();
  final  _emailController = TextEditingController();
  final  _passwordController = TextEditingController();
  final  _bioController = TextEditingController();
  final _userNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passFocusNode = FocusNode();
  final _bioFocusNode = FocusNode();
  final  _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _userNameController.dispose();
    _bioController.dispose();
    _userNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _bioFocusNode.dispose();
    super.dispose();
  }
  bool _isLoading= false;

  Future<void> signupForm() async{
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if(isValid){
      _formKey.currentState!.save();
      // if (pickedImage == null) {
      //   GlobalMethods.showErrorDialog(
      //     content: 'Please pick up an image', context: context,);
      //   return;
      // }
    var imgUrl;
      if(pickedImage == null){
        imgUrl = '';
      }
      try{
        setState(() =>_isLoading = true);
        //user registration
       await authInstance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // get current user id
        final User? user = authInstance.currentUser;
        final uId = user!.uid;

         //set username for using later
        user.updateDisplayName(_userNameController.text);
        user.reload();

          if(pickedImage != null) {
            // // upload user image to storage
            imgUrl = await StorageMethods().uploadImageToStorage(
                img: pickedImage, childName: 'profileImage');
          }
        // // upload user image to storage
        // final ref = FirebaseStorage.instance.ref().child('userProfile').child(uId);
        //  await  ref.putData(pickedImage!);
        //  String? imgUrl =await ref.getDownloadURL();


        UserModel userModel= UserModel(
          email: _emailController.text.trim(),
          uId: uId,
          imgUrl: imgUrl,
          userName: _userNameController.text,
          bio: _bioController.text,
          followers: [],
          following: [],
        );
        //upload data to firebase firestore
        await FirebaseFirestore.instance.collection('users').doc(uId).set(userModel.toJson());        //upload data to firebase firestore
        // await FirebaseFirestore.instance.collection('users').doc(uId).set({
        //   'uId':uId,
        //   'userName':_userNameController.text,
        //   'email':_emailController.text.trim(),
        //   'bio':_bioController.text,
        //   'followers':[],
        //   'following':[],
        //   'imageUrl':imgUrl
        // });
        if(mounted){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MobileScreenLayout(),));
        }
      }on FirebaseException catch(error){
        setState(() =>_isLoading = false);
        if(mounted){
          GlobalMethods.showErrorDialog(
              context: context,
              content: error.message.toString());
        }

      }catch(error){
        setState(() =>_isLoading = false);
        toastMsg(msg: error.toString());
      }finally{
        setState(() =>_isLoading = false);
      }
    }


  }

  @override
  Widget build(BuildContext context) {

 final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: LoadingManager(
            isLoading: _isLoading,
            child: Container(
              margin:EdgeInsets.symmetric(horizontal: width>webScreenSize? width*0.3:0 ), //
              padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                 // Flexible(flex: 2,child: Container(),),
                  const SizedBox(height: 12,),
                  SvgPicture.asset('assets/images/logo/ic_instagram.svg',
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),              height: 64,
                  ),
                  const SizedBox(height: 12,),
                  Stack(
                    children: [
                      pickedImage != null ?
                       CircleAvatar(
                        radius: 64,
                        backgroundImage: MemoryImage(pickedImage!)
                      ):const CircleAvatar(
                        radius: 64,
                        backgroundImage:  NetworkImage('https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg'),
                      ),
                      Positioned(
                        right: 10,
                          bottom: -10,
                          child: IconButton(
                        onPressed: () {
                          pickImage(source: ImageSource.gallery);
                        },
                        icon: const Icon(Icons.add_a_photo),
                      ))
                    ],
                  ),
                  const SizedBox(height: 12,),
                  TextFieldInput(
                    controller: _userNameController,
                    textInputType: TextInputType.text,
                    hintText: 'Enter you username',
                    validator: (String? value) {
                     return value!.isEmpty || value.length <2?'Please enter username' :null;
                    },
                    textInputAction: TextInputAction.next,
                    focusNode: _userNameFocusNode,
                  ),
                  const SizedBox(
                    height: 12,
                  ),TextFieldInput(
                    controller: _emailController,
                    textInputType: TextInputType.emailAddress,
                    hintText: 'Enter you email',
                    validator: (String? value) {
                      return value!.isEmpty || !value.contains('@')?'Please enter valid email' :null;
                    }, textInputAction: TextInputAction.next, focusNode: _emailFocusNode,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFieldInput(
                    controller: _passwordController,
                    textInputType: TextInputType.visiblePassword,
                    obscureText: true,
                    hintText: 'Enter your password',
                    validator: (String? value) {
                      return value!.isEmpty || value.length <6?'Password at least 6 char' :null;
                    }, textInputAction: TextInputAction.next, focusNode: _passFocusNode,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFieldInput(
                    controller: _bioController,
                    textInputType: TextInputType.text,
                    hintText: 'Enter you bio',
                    validator: (String? value) {
                      return value!.isEmpty || value.length <5?'Please enter bio' :null;
                    }, textInputAction: TextInputAction.done, focusNode: _bioFocusNode,
                  ),

                  const SizedBox(
                    height: 24,
                  ),
                  InkWell(
                    onTap: () async {
                     await signupForm();
                    },
                    child: Container(
                      height: kToolbarHeight,
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: ShapeDecoration(shape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ) ,
                          color: blueColor
                      ),
                      child: const Text('Sign up'),
                    ),
                  ),

                  // Flexible(flex: 2,child: Container(),),
                  // const SizedBox(height: 12,),
                  //

                ],
              ),
            ),
                    ),
                  ),
          )),
    );
  }

  Uint8List? pickedImage;

  Future<void> pickImage({required ImageSource source}) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? image = await imagePicker.pickImage(source: source);
    if (image != null) {
      var selected = await image.readAsBytes();
      setState(() {
        pickedImage = selected;
      });
    }
  }
}


