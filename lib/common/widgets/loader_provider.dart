import 'package:flutter/widgets.dart';

class ShowLoader with ChangeNotifier{
  bool showLoader;
  bool showLoader2;

  ShowLoader(this.showLoader,this.showLoader2);
  void startLoader()
  {
    showLoader = true;
    notifyListeners();
  }void startLoader2()
  {
    showLoader2 = true;
    notifyListeners();
  }
  void stopLoader()
  {
    showLoader = false;
    notifyListeners();
  }void stopLoader2()
  {
    showLoader2 = false;
    notifyListeners();
  }
}