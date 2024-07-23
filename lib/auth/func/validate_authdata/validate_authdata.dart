import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tag_book/auth/screen/login/log_in.dart';

import '../../../Menu/MyTags/wigdets/fetch_tags.dart';


//locally validating userEntered Data
class UserValidator extends ChangeNotifier {
  bool validUserId = true;
  bool validPassKey = true;
  bool validRePassKey = true;

  void wongUserId()
  {
    validUserId = false;
    notifyListeners();
  }
  void inValidateValues()
  {
    validUserId = false;
    validPassKey = false;
    notifyListeners();
  }

  void validateValues(){
    validUserId = true;
    validPassKey = true;
    notifyListeners();
  }

  void validateUserID(String userId) {

    bool isValid = userId.isNotEmpty && userId.length >= 10 && userId.length <= 14;
    if (validUserId != isValid) {
      validUserId = isValid;
      notifyListeners();
    }
  }

  void validatePassword(String passKey) {
    bool isValid = passKey.isNotEmpty && passKey.length >= 8 && checkValid(passKey);
    if (validPassKey != isValid) {
      validPassKey = isValid;
      notifyListeners();
    }
  }

  void validateRePassword(String rePassKey, String passKey) {
    bool isValid = passKey == rePassKey;
    if (validRePassKey != isValid) {
      validRePassKey = isValid;
      notifyListeners();
    }
  }



}
bool checkValid(String value) {
  String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(value);
}

//logout Func
Future<bool> _performLogout() async {
  // Get instance of SharedPreferences
  posts.clear();
  tags.clear();
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Remove the token and other user-related data

  bool removedToken = await prefs.remove('authToken');
  bool removedPosts = await prefs.remove('Posts');
  bool removedList  = await prefs.remove('tags');
  bool removedIcons = await prefs.remove('Icons');

  return removedToken && removedIcons && removedList && removedPosts;
}
void logout(BuildContext context) {
  _performLogout().then((isSuccess) {
    if (isSuccess == true) {
      // Display a message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged out successfully!')),
      );

      // Navigate to the login screen
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>ChangeNotifierProvider(create:(context)=>UserValidator(),child: const LogIn()),), (route) => false);
    } else {
      // Display an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout failed. Please try again.')),
      );
    }
  },);
}


