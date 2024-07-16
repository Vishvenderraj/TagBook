import 'package:flutter/cupertino.dart';

import 'Menu/MyTags/wigdets/fetch_tags.dart';

List<String> listOfFilterIds = [];
List<FetchPosts> filteredPosts = [];
bool filterOn = false;



class TagBookProvider extends ChangeNotifier {
  String _tagTitles1 = 'Select Tag 1',_tagTitles2 = 'Select Tag 2',_tagTitles3 = 'Select Tag 3';
   String _imagesUsed1 = '',_imagesUsed2 = '',_imagesUsed3 = '';
   String _tagID1 = '',_tagID2 = '',_tagID3 = '';


  String get getTagTitle1 => _tagTitles1;
  String get getImageTitle1 => _imagesUsed1;
  String get getTagID1 => _tagID1;

  String get getTagTitle2 => _tagTitles2;
  String get getImageTitle2 => _imagesUsed2;
  String get getTagID2 => _tagID2;

  String get getTagTitle3 => _tagTitles3;
  String get getImageTitle3 => _imagesUsed3;
  String get getTagID3 => _tagID3;

  void changeTitle1(String title) {
    _tagTitles1 = title;
    notifyListeners();
  }
  void changeTitle2(String title) {
    _tagTitles2 = title;
    notifyListeners();
  }
  void changeTitle3(String title) {
    _tagTitles3 = title;
    notifyListeners();
  }

  void setDefaultValues(){
    _tagTitles1 = 'Select Tag 1';
    _tagTitles2 = 'Select Tag 2';
    _tagTitles3 = 'Select Tag 3';

    _imagesUsed1 = '';
    _imagesUsed2 = '';
    _imagesUsed3 = '';

    _tagID1='';
    _tagID2='';
    _tagID3='';

    notifyListeners();
  }


  void changeImage1(String image) {
    _imagesUsed1 = image;
    notifyListeners();
  }
  void changeImage2(String image) {
    _imagesUsed2 = image;
    notifyListeners();
  }
  void changeImage3(String image) {
    _imagesUsed3 = image;
    notifyListeners();
  }

  void setTagID1(String tagID){
    _tagID1 = tagID;
    notifyListeners();
  }
  void setTagID2(String tagID){
    _tagID2 = tagID;
    notifyListeners();
  }
  void setTagID3(String tagID){
    _tagID3 = tagID;
    notifyListeners();
  }
}
class TagBookProvider2 extends ChangeNotifier {
  String _tagTitles1 = 'Select Tag 1',_tagTitles2 = 'Select Tag 2',_tagTitles3 = 'Select Tag 3';
   String _imagesUsed1 = '',_imagesUsed2 = '',_imagesUsed3 = '';
   String _tagID1 = '',_tagID2 = '',_tagID3 = '';


  String get getTagTitle1 => _tagTitles1;
  String get getImageTitle1 => _imagesUsed1;
  String get getTagID1 => _tagID1;

  String get getTagTitle2 => _tagTitles2;
  String get getImageTitle2 => _imagesUsed2;
  String get getTagID2 => _tagID2;

  String get getTagTitle3 => _tagTitles3;
  String get getImageTitle3 => _imagesUsed3;
  String get getTagID3 => _tagID3;

  void changeTitle1(String title) {
    _tagTitles1 = title;
    notifyListeners();
  }
  void changeTitle2(String title) {
    _tagTitles2 = title;
    notifyListeners();
  }
  void changeTitle3(String title) {
    _tagTitles3 = title;
    notifyListeners();
  }

  void setDefaultValues(){
    _tagTitles1 = 'Select Tag 1';
    _tagTitles2 = 'Select Tag 2';
    _tagTitles3 = 'Select Tag 3';

    _imagesUsed1 = '';
    _imagesUsed2 = '';
    _imagesUsed3 = '';

    _tagID1='';
    _tagID2='';
    _tagID3='';

    notifyListeners();
  }


  void changeImage1(String image) {
    _imagesUsed1 = image;
    notifyListeners();
  }
  void changeImage2(String image) {
    _imagesUsed2 = image;
    notifyListeners();
  }
  void changeImage3(String image) {
    _imagesUsed3 = image;
    notifyListeners();
  }

  void setTagID1(String tagID){
    _tagID1 = tagID;
    notifyListeners();
  }
  void setTagID2(String tagID){
    _tagID2 = tagID;
    notifyListeners();
  }
  void setTagID3(String tagID){
    _tagID3 = tagID;
    notifyListeners();
  }
}
