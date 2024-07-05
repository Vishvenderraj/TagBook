import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tag_book/auth/data/Fetch_ApiData/fetch_apidata.dart';



Future<bool> createTag(String tagName, String icon, String description) async {
  String url = 'https://tag-book-1.onrender.com/api/v1/common/createTag';
  final createTag = await http.post(
    Uri.parse(url),
    headers: {
      "Authorization": "Bearer $returnIfToken",
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "tagName": tagName,
      "icon": icon,
      "description": description,
    }),
  );

  if (createTag.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
Future<bool> editTag(String tagName) async{
  String url = '';
  final editTag = await http.put(Uri.parse(url),
  headers: {
    "Authorization":"Bearer $returnIfToken",
    "Content-Type":"application/json",
  },
    body: jsonEncode({"tagName":tagName},
    ),
  );
  if(editTag.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<bool> getAllTag()async{
  String url = '';
  final getAllTags = await http.get(Uri.parse(url),
  headers: {"Content-type":"application/json"},);

  if(getAllTags.statusCode == 200)
    {
      return true;
    }
  else
    {
      return false;
    }
}