import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> sentFeedback(String type, String descriptions, List<String?> image) async{
  try{
    String url = 'https://tag-book-1.onrender.com/api/v1/common/createUserInteractions';
    final pref = await SharedPreferences.getInstance();
    final Map<String, dynamic> body = {
      "descriptions": descriptions,
      "uploadImages": image, // Assuming this contains URLs for the images
      "types": type,
    };
    final String jsonBody = jsonEncode(body);
    final feed = await http.post(Uri.parse(url),

      headers: {
        "Authorization" : "Bearer ${pref.getString("authToken")}",
        "Content-type" : "application/json"
      },
      body: jsonBody
    );
    print(feed.body);
    if(jsonDecode(feed.body)["code"] == 200)
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