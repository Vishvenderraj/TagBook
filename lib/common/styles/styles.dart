import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

textStyle(double size, FontWeight weight, Color color){
  return TextStyle(
    fontSize: size, fontWeight: weight, color: color
  );
}


class SpacedBoxLarge extends StatelessWidget {
  const SpacedBoxLarge({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(height:  MediaQuery.sizeOf(context).height * 0.032);
  }
}

class SpacedBoxBig extends StatelessWidget {
  const SpacedBoxBig({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return SizedBox(height:  MediaQuery.sizeOf(context).height * 0.024);
  }
}

class SpacedBox extends StatelessWidget {
  const SpacedBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: MediaQuery.sizeOf(context).height*0.012,);
  }
}

class  Counter with ChangeNotifier{
  late bool isPressed = false;
  void change()
  {
     isPressed = !isPressed;
     notifyListeners();
  }
}

class Tapped with ChangeNotifier{
  bool isTapped;
  Tapped(this.isTapped);
  void tapped(){
    isTapped = !isTapped;
    notifyListeners();
  }
}

class ResponsiveTexts extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign textAlign;
  const ResponsiveTexts({super.key, required this.text, required this.style, required this.textAlign});

  @override
  Widget build(BuildContext context) {

    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        text: text,
        style: style,
      ),
    );
  }
}


