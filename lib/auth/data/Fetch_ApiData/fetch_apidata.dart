import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../func/validate_authdata/validate_authdata.dart';

Future<bool>resetPassword(String mobile,String password) async {
  final userID = await http.put(
      Uri.parse('https://tag-book-1.onrender.com/api/v1/auth/resetPassword'),
      headers: {"Content-Type": "application/json; charset=utf-8",},
      body: jsonEncode({"mobile":mobile,"password": password})
  );
  if (userID.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
Future<bool> checkUserData(String mobile)async{
  try{
    final userID = await http.post(Uri.parse('https://tag-book-1.onrender.com/api/v1/auth/verifyUser'),
      headers: {"Content-Type": "application/json; charset=utf-8",},
      body: jsonEncode({
        "mobile":mobile,
      },),);

    if(userID.statusCode == 200)
    {
      return true;
    }
    else
    {
      return false;
    }
  }
  catch(e){
    debugPrint(e.toString());
    return false;
  }
}

Future<bool> logInSignup(String mobile, String password, String type) async {


  // Define the endpoint URL
  String url = 'https://tag-book-1.onrender.com/api/v1/auth/login'; // Adjust URL if needed

  try {
    // Make POST request
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "mobile": mobile,
        "password": password,
        "type": type,
      }),
    );
    // Check response status code
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Login or signup successful
      if(type == "login") {
        token = jsonDecode(response.body)["token"];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', token);
      }// Extract token from response
      // Store token using SharedPreferences or similar method for future API requests
      return true; // Return true to indicate success
    }
  } catch (e) {
    // Handle any exceptions that occur during the HTTP request
    debugPrint('Exception occurred: $e');
    return false; // Return false in case of exception
  }
  return false;
}