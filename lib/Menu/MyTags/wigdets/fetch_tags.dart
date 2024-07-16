import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

List<FetchTags>tags = [];
List<FetchPosts>posts = [];

//Post API
class FetchPosts{
  final String content;
  final String image1;
  final String image2;
  final String image3;
  final String dateCreated;
  FetchPosts({ required this.content, required this.image1, required this.image2, required this.image3, required this.dateCreated,});
  factory FetchPosts.fromJson(Map<String, dynamic> json)
  {
    List<dynamic> tagIdList = json['tagId'] ?? [];
    String image1 = tagIdList.isNotEmpty ? tagIdList[0]['icon']['iconImage'] ?? '' : '';
    String image2 = tagIdList.length > 1 ? tagIdList[1]['icon']['iconImage'] ?? '' : '';
    String image3 = tagIdList.length > 2 ? tagIdList[2]['icon']['iconImage'] ?? '' : '';


    return FetchPosts(
      content: json['content'],
      image1: image1,
      image2: image2,
      image3: image3,
      dateCreated: json['createdAt'],
    );
  }
}

Future<bool> createPost(String content, List<String> listoftags) async{

  String url = 'https://tag-book-1.onrender.com/api/v1/common/createPost';
  final pref = await SharedPreferences.getInstance();
  
  try{
    final createPost = await http.post(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer ${pref.getString('authToken')}",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "content": content,
        "tagId": listoftags,
      }),
    );
    print('${pref.getString('authToken')}');
    print(createPost.statusCode);
    print(jsonDecode(createPost.body)['code']);
    if(jsonDecode(createPost.body)['code'] == 201)
      {
        print("ok");
        return true;
      }
    else
      {
        print("f");
        return false;
      }
  }
  catch(e){
    print(e);
    return false;
  }

}
Future<List<FetchPosts>> getAllPosts() async{
  final pref = await SharedPreferences.getInstance();
  String url = 'https://tag-book-1.onrender.com/api/v1/common/getPost/';

  final getAllPosts = await http.get(Uri.parse(url),
    headers: {
      "Authorization": "Bearer ${pref.getString('authToken')}",
      "Content-type": "application/json"
    },
  );
  if(getAllPosts.statusCode == 200)
    {
      List<dynamic> data = json.decode(getAllPosts.body)['data'];
      posts = data.map((post) => FetchPosts.fromJson(post)).toList();
      return data.map((post) => FetchPosts.fromJson(post)).toList();

    }
  else
    {
      throw Exception("faulty");
    }
}


//Tags API
class FetchTags {
  final String tagID;
  final String iconImage;
  final String tagName;
  final String iconID;
  final String descr;

  FetchTags({required this.tagID, required this.tagName, required this.iconImage,required this.iconID, required this.descr, });

  factory FetchTags.fromJson(Map<String, dynamic> json) {
    return FetchTags(
      tagID: json['_id'] ?? '',
      tagName: json['tagName'] ?? '',
      iconImage: json['icon']['iconImage'] ?? '',
      iconID: json['icon']['_id'] ?? '',
      descr: json['description'] ,

    );
  }
}


Future<List<FetchTags>> getAllTag() async {
  final pref = await SharedPreferences.getInstance();
  String url = 'https://tag-book-1.onrender.com/api/v1/common/getAllTags';

  final getAllTags = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer ${pref.getString('authToken')}',
      'Content-Type': 'application/json',
    },
  );

  if (getAllTags.statusCode == 200) {

    List<dynamic> data = json.decode(getAllTags.body)['data'];
    tags = data.map((tag) => FetchTags.fromJson(tag)).toList();
    return data.map((tag) => FetchTags.fromJson(tag)).toList();
  } else {
    throw Exception("none works");
  }
}
Future<bool> createTag(String tagName, String icon, String description) async {
  String url = 'https://tag-book-1.onrender.com/api/v1/common/createTag';
  final pref = await SharedPreferences.getInstance();

  try {
    final createTag = await http.post(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer ${pref.getString('authToken')}",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "tagName": tagName,
        "icon": icon,
        "description": description,
      }),
    );
    print( jsonDecode(createTag.body)['code']);
    print( pref.getString('authToken'));
    if (createTag.statusCode == 200 && jsonDecode(createTag.body)['code']!=401) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}
Future<bool> editTag({required String tagName, required String tagID, required String iconID, required String description}) async {
  final pref = await SharedPreferences.getInstance();
  try {
    String url = 'https://tag-book-1.onrender.com/api/v1/common/editTag/$tagID';
    final editTag = await http.put(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer ${pref.getString('authToken')}",
        "Content-Type": "application/json",
      },
      body: jsonEncode(
        {
          "tagName": tagName,
          "icon": iconID,
          "description": description,
        },
      ),
    );

    if (editTag.statusCode == 200 && jsonDecode(editTag.body)['code'] == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    debugPrint(e.toString());
    return false;
  }
}
Future<bool> deleteTag(String tagId) async {
  final pref = await SharedPreferences.getInstance();
  String authToken = pref.getString('authToken') ?? '';

  String url = 'https://tag-book-1.onrender.com/api/v1/common/deleteTagPost/$tagId?type=deleteTag';

  final deleteTagResponse = await http.delete(
    Uri.parse(url),
    headers: {
      "Authorization": "Bearer $authToken",
      "Content-Type": "application/json",
    },
  );

  if (deleteTagResponse.statusCode == 200) {
    final responseJson = jsonDecode(deleteTagResponse.body);
    print(responseJson['code']); // Printing the response code
    return responseJson['code'] == 200;
  } else {
    print('Failed to delete tag. Status code: ${deleteTagResponse.statusCode}');
    return false;
  }
}