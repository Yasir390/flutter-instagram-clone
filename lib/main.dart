import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/responsive_layout_screen.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/firebase_const.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    User? user = authInstance.currentUser;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram Clone',
        theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: mobileBackgroundColor),

       // home: const LoginScreen() ,// another alternative has
        home:user == null? const LoginScreen(): const ResponsiveLayout(webScreenLayout: WebScreenLayout(), mobileScreenLayout: MobileScreenLayout()), // another alternative has

      ),
    );
  }
}







//  home: StreamBuilder(
//    stream:FirebaseAuth.instance.authStateChanges() ,
//    builder: (context, snapshot) {
//      if(snapshot.connectionState == ConnectionState.active){
//        if(snapshot.hasData){
//          return const ResponsiveLayout(
//            webScreenLayout: HomeScreen(),
//            mobileScreenLayout: HomeScreen(),
//          );
//        }else if(snapshot.hasError){
//          return Center(child: Text(snapshot.error.toString()),);
//        }
//      }
//      else if(snapshot.connectionState == ConnectionState.waiting){
//        return const Center(
//          child: CircularProgressIndicator(
//            color: primaryColor,
//          ),
//        );
//      }
//
//        return const LoginScreen();
//
//    },
//  ),