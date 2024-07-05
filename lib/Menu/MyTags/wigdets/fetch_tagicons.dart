
import 'dart:convert';
import 'package:http/http.dart' as http;


class FetchIcons {
  final String id;
  final String iconImage;

  FetchIcons({required this.id, required this.iconImage});

  factory FetchIcons.fromJson(Map<String, dynamic> json) {
    return FetchIcons(
      id: json['_id'],
      iconImage: json['iconImage'],
    );
  }
}

Future<List<FetchIcons>>fetchAllIconData()async{

  String url = 'https://tag-book-1.onrender.com/api/v1/master/getAllTagIcons';
  final getIcons = await http.get(Uri.parse(url),
    headers: {"Content-Type":"application/json"},
  );

  if(getIcons.statusCode == 200)
  {
    final List<dynamic>data = jsonDecode(getIcons.body)['data'];
    return data.map((item) => FetchIcons.fromJson(item)).toList();

  }
  else
  {
    throw Exception('wrong');
  }
}