import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

List<FetchIcons> iconList =[];
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
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'iconImage': iconImage,
    };
  }
}

Future<void>getAllIcons()async{
  String url = 'https://tag-book-1.onrender.com/api/v1/master/getAllTagIcons';
  final pref = await SharedPreferences.getInstance();
  final getIcons = await http.get(Uri.parse(url),
    headers: {"Content-Type":"application/json"},
  );

  if(getIcons.statusCode == 200)
  {
    final List<dynamic>data = jsonDecode(getIcons.body)['data'];
    List<FetchIcons> listOfIcons = data.map((item) => FetchIcons.fromJson(item)).toList();
    String iconJson = json.encode(listOfIcons.map((icons) => icons.toJson()).toList());

    await pref.setString('Icons', iconJson);

  }
  else
  {
    throw Exception('wrong');
  }
}
Future<void> getStoredIcons() async {
  final pref = await SharedPreferences.getInstance();
  pref.getString('Icons')!.isEmpty? await getAllIcons():null;
  String? iconJson = pref.getString('Icons');

  if (iconJson != null) {
    List<dynamic> data = json.decode(iconJson);
    iconList = data.map((icon) => FetchIcons.fromJson(icon)).toList();
  } else {
    throw Exception('Failed to Icons');
  }
}