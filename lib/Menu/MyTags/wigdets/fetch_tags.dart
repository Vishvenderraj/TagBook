import 'dart:async';
import 'dart:convert';
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
  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'tagId': [
        {
          'icon': {'iconImage': image1}
        },
        {
          'icon': {'iconImage': image2}
        },
        {
          'icon': {'iconImage': image3}
        }
      ],
      'createdAt': dateCreated,
    };
  }
}

Future<bool> createPost(String content, List<String> listOfTags) async{

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
        "tagId": listOfTags,
      }),
    );
    if(jsonDecode(createPost.body)['code'] == 201)
      {
        return true;
      }
    else
      {
        return false;
      }
  }
  catch(e){
    print(e);
    return false;
  }

}

Future<void> getAllPosts() async{
  final pref = await SharedPreferences.getInstance();
  String url = 'https://tag-book-1.onrender.com/api/v1/common/getPost/';

  final getAllPosts = await http.get(Uri.parse(url),
    headers: {
      "Authorization": "Bearer ${pref.getString('authToken')}",
      "Content-type": "application/json"
    },
  );
  print(getAllPosts.statusCode);
  if(getAllPosts.statusCode == 200 && json.decode(getAllPosts.body)['code'] == 200)
    {

      List<dynamic> data = json.decode(getAllPosts.body)['data'];
      String postJson ='';
      if(data.isNotEmpty)
     {
       List<FetchPosts> allPosts = data.map((post) => FetchPosts.fromJson(post)).toList();
       postJson = json.encode(allPosts.map((post) => post.toJson()).toList());
       posts = data.map((tag) => FetchPosts.fromJson(tag)).toList();
     }

      await pref.setString('Posts', postJson);
    }
  else
    {
       return;
    }
}
Future<void> getStoredPosts() async {
  final pref = await SharedPreferences.getInstance();
  String? postJson = pref.getString('Posts');

  if (postJson != null) {
    List<dynamic> data = json.decode(postJson);
    posts = data.map((tag) => FetchPosts.fromJson(tag)).toList();
  }
  else
    {
      await getAllPosts();
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
  Map<String, dynamic> toJson() {
    return {
      '_id': tagID,
      'tagName': tagName,
      'icon': {
        'iconImage': iconImage,
        '_id': iconID,
      },
      'description': descr,
    };
  }
}

Future<void> getStoredTags() async {
  final pref = await SharedPreferences.getInstance();
  String? tagsJson = pref.getString('tags');

  if (tagsJson != null) {
    List<dynamic> data = json.decode(tagsJson);
    tags = data.map((tag) => FetchTags.fromJson(tag)).toList();
  }
  else
  {
     await getAllTag();
  }
}
Future<void> getAllTag() async {
  final pref = await SharedPreferences.getInstance();
  String url = 'https://tag-book-1.onrender.com/api/v1/common/getAllTags';

  final getAllTags = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer ${pref.getString('authToken')}',
      'Content-Type': 'application/json',
    },
  );
  print(json.decode(getAllTags.body)['message']);
  if (getAllTags.statusCode == 200 && json.decode(getAllTags.body)['code']==200) {

    List<dynamic> data = json.decode(getAllTags.body)['data'];
    List<FetchTags> listOfTags =  data.map((tag) => FetchTags.fromJson(tag)).toList();
    tags = data.map((tag) => FetchTags.fromJson(tag)).toList();
    String tagsJson = json.encode(listOfTags.map((tag) => tag.toJson()).toList());

    await pref.setString('tags', tagsJson);
  } else {
    throw Exception("Failed to load tags");
  }
}

/*Future<void> getStoredOrFetchTags() async {
  final pref = await SharedPreferences.getInstance();
  String? tagsJson = pref.getString('tags');

  if (tagsJson == null || tagsJson.isEmpty) {
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
      List<FetchTags> listOfTags = data.map((tag) => FetchTags.fromJson(tag)).toList();
      tagsJson = json.encode(listOfTags.map((tag) => tag.toJson()).toList());

      await pref.setString('tags', tagsJson);
    } else {
      throw Exception("Failed to load tags");
    }
  }

  if (tagsJson.isNotEmpty) {
    List<dynamic> data = json.decode(tagsJson);
    tags = data.map((tag) => FetchTags.fromJson(tag)).toList();
  } else {
    throw Exception('Failed to load Tags');
  }
}*/



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
    if (editTag.statusCode == 200 && jsonDecode(editTag.body)["code"]==200) {
      return true;
    } else {
      print("fkl");
      return false;
    }
}
Future<bool> deleteTag(String tagId) async {
  final pref = await SharedPreferences.getInstance();
  String authToken = pref.getString('authToken') ?? '';

  print(tagId);
  print(tagId);
  String url = 'https://tag-book-1.onrender.com/api/v1/common/deleteTagPost/$tagId?type=deleteTag';

  final deleteTagResponse = await http.delete(
    Uri.parse(url),
    headers: {
      "Authorization": "Bearer $authToken",
      "Content-Type": "application/json",
    },
  );

  if (deleteTagResponse.statusCode == 200 && jsonDecode(deleteTagResponse.body)['code'] == 200 ) {
      return true;
  } else {
    print('Failed to delete tag. Status code: ${jsonDecode(deleteTagResponse.body)}');
    return false;
  }
}