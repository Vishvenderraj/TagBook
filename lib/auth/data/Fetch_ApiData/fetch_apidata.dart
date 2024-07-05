import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

String _token = '';
String get returnIfToken =>_token;

Future<bool> resetPassword(String mobile, String password) async {
  final userID = await http.put(
      Uri.parse('https://tag-book-1.onrender.com/api/v1/auth/resetPassword'),
      headers: {
        "Content-Type": "application/json; charset=utf-8",
      },
      body: jsonEncode({"mobile": mobile, "password": password}));
  if (userID.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
String? _mobile;
String? _reg;

String? get userId => _mobile;
String? get registeredDate => _reg;

Future<void> fetchUserData() async {
  final fetchData = await http.get(Uri.parse('https://tag-book-1.onrender.com/api/v1/auth/getUserProfile'),
      headers: {
        'Authorization': 'Bearer $returnIfToken',
        'Content-Type': 'application/json',
      },
  );
  if (fetchData.statusCode == 200) {

    final Map<String,dynamic> data = json.decode(fetchData.body);
    if(data['code'] == 200 && data['status'] == 'Success')
      {
        _mobile = data['data']['mobile'].toString();
        _reg = data['data']['createdAt'];
      }
    else
      {
          throw Exception('Failed to load UserData');
      }
  } else {
    throw Exception('Failed to load UserData');
  }
}

Future<bool> checkUserData(String mobile) async {

  try {
    final userID = await http.post(
      Uri.parse('https://tag-book-1.onrender.com/api/v1/auth/verifyUser'),
      headers: {
        "Content-Type": "application/json; charset=utf-8",
      },
      body: jsonEncode(
        {
          "mobile": mobile,
        },
      ),
    );

    if (userID.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    debugPrint(e.toString());
    return false;
  }
}

String? _subtitle;
String? _description;
List<String> terms = _description!.split(',,');

String get getSubtitle => _subtitle!;

Future<void> getPolicies()async {
    final response = await http.get(Uri.parse('https://tag-book-1.onrender.com/api/v1/public/getPolicies?type=termsAndConditions'),
    headers: {"Content-Type":"application/json"},);


        final Map<String,dynamic> responseBody = jsonDecode(response.body);
        List<dynamic>? dataList = responseBody['data'];
        if(dataList!.isNotEmpty)
          {
             _subtitle = dataList[0]['subTitle'];
             _description = dataList[0]['descriptions'];
          }


    else
      {
        throw Exception("Couldn't find any policies");
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
      if (type == "login") {
        _token = jsonDecode(response.body)["token"];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', _token);
      } // Extract token from response
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
