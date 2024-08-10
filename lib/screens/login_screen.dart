import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/screens/signup_screen.dart';
import 'package:instagram_clone/services/loading_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/dimensions.dart';
import 'package:instagram_clone/utils/style.dart';
import 'package:instagram_clone/widget/text_field_input.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';
import '../services/flutter_toast.dart';
import '../services/global_methods.dart';
import '../utils/firebase_const.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final  _emailFocusNode = FocusNode();
  final  _passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> loginForm() async{
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if(isValid){
      _formKey.currentState!.save();
      try{
        setState(() =>_isLoading = true);
        //user sign in
       await authInstance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
       if(mounted){
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ResponsiveLayout(webScreenLayout: WebScreenLayout(), mobileScreenLayout: MobileScreenLayout())));
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


    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: LoadingManager(
            isLoading: _isLoading,
            child: Container(
                   padding: MediaQuery.of(context).size.width > webScreenSize ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/3 )
                  : const EdgeInsets.symmetric(horizontal: 32),
                    child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(flex: 2,child: Container(),),
                SvgPicture.asset('assets/images/logo/ic_instagram.svg',
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ), height: 64,
                ),
                const SizedBox(height: 12,),
                TextFieldInput(
                  controller: _emailController,
                  textInputType: TextInputType.emailAddress,
                  hintText: 'Enter you email',
                  validator: (String? value) {
                    return value!.isEmpty || !value.contains('@')?'Please enter email' :null;
                  }, textInputAction: TextInputAction.next,
                  focusNode: _emailFocusNode,
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
                    return value!.isEmpty || value.length <2?'Please enter valid password' :null;
                  }, textInputAction: TextInputAction.done,
                  focusNode: _passwordFocusNode,),
               const SizedBox(
                 height: 24,
               ),
                InkWell(
                  onTap: () async {
                   await loginForm();
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
                    child: const Text('Log in'),
                  ),
                ),

                Flexible(flex: 2,child: Container(),),
                const SizedBox(height: 12,),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have account?"),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupScreen(),));
                        },
                        child: const Text(' Sign up',style: TextStyle(fontWeight: FontWeight.bold),))
                  ],
                ),
                const SizedBox(height: 12,),

              ],
            ),),
            ),
          )),
    );
  }
}


