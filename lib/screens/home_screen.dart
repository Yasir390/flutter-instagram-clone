import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/signup_screen.dart';
import 'package:instagram_clone/utils/firebase_const.dart';
import 'package:provider/provider.dart';
import '../provider/user_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    await Provider.of<UserProvider>(context, listen: false).loadUserData();
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:  Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (userProvider.error.isNotEmpty) {
            return Center(child: Text("Error: ${userProvider.error}"));
          } else if (userProvider.getUser == null) {
            return const Center(child: Text("No user data available"));
          } else {
            return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(userProvider.getUser!.email),
                    Text(userProvider.getUser!.bio),
                    Text(userProvider.getUser!.userName),
                    TextButton(
                      onPressed: () async {
                        await authInstance.signOut().then((value) {
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) => const SignupScreen(),));
                        });
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                )
            );
          }
        }
        )
    );

  }
}
