import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  AuthMethods authMethods = AuthMethods();
  UserModel? _userModel;
  bool isLoading = true;
  String error = '';

  UserModel? get getUser => _userModel;

  Future<void> loadUserData() async {
    isLoading = true;
    error = '';
    notifyListeners();

    try {
      _userModel = await authMethods.getUserDetails();
      isLoading = false;
    } catch (e) {
      print("Error loading user data: $e");
      error = e.toString();
      isLoading = false;
    }
    notifyListeners();
  }

  Future<void> refreshUser() async {
    await loadUserData();
  }
}