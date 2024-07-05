import 'package:flutter/material.dart';

class IconProvider with ChangeNotifier {
  String? _selectedTagId;

  String? get selectedTagId => _selectedTagId;

  void selectTag(String tagId) {
    _selectedTagId = tagId;
    notifyListeners(); // Notify listeners to rebuild widgets
  }
}

