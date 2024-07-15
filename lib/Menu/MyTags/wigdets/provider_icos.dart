import 'package:flutter/material.dart';

class IconProvider with ChangeNotifier {
  String? _selectedIconId;
  bool _isSelected = true;

  String? get selectedIconId => _selectedIconId;
  bool get isSelected => _isSelected;

  void selectTag(String iconID) {
    _selectedIconId = iconID;
    _isSelected = true;
    notifyListeners(); // Notify listeners to rebuild widgets
  }

  bool checkIfSelected(String? iconID){
    return iconID == null || iconID.isEmpty?_isSelected = false: _isSelected = true;
  }

}

class TagEditProvider with ChangeNotifier{
   bool _tagNameValid = true;
   bool _tagDescription  = true;

  bool get validTagName => _tagNameValid;
  bool get validDescr => _tagDescription;

  void checkIfValidInput(bool isTagNameValid, bool isTagDescrValid){
    isTagNameValid == false? _tagNameValid = true : _tagNameValid = false;
    isTagDescrValid == false? _tagDescription = true : _tagDescription = false;
    notifyListeners();
  }


}

