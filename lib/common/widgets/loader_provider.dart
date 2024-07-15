import 'package:flutter/widgets.dart';

class ShowLoader with ChangeNotifier{
  bool showLoader = false;
  void startLoader()
  {
    showLoader = true;
    notifyListeners();
  }
  void stopLoader()
  {
    showLoader = false;
    notifyListeners();
  }
}