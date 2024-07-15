import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../styles/styles.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.text,
    required this.iconData,
    required this.maxLen,
    required this.suffixIcon,
    required this.preffixIcon,
    required this.func,
    required this.controller,
    required this.keyboardType,
    required this.validField,
    required this.onPressed,
    required this.visibility,

  });
  final String text;
  final IconData? iconData;
  final int maxLen;
  final bool suffixIcon;
  final bool preffixIcon;
  final TextEditingController? controller;
  final Function(String?) func;
  final TextInputType keyboardType;
  final bool validField;
  final Function() onPressed;
  final bool visibility;
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.sizeOf(context).height;
    var screenWidth = MediaQuery.sizeOf(context).width;
    return  Container(
        height: screenHeight * 0.06,
        width: screenWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: validField? Colors.grey.shade400:Colors.red,
          ),
        ),
        child: TextFormField(
          obscureText: visibility,
          onTapOutside: (PointerDownEvent event){
            FocusManager.instance.primaryFocus?.unfocus();
          },
          textAlignVertical: TextAlignVertical.top,
          textAlign: TextAlign.start,
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical:  screenHeight * 0.022),
            hintText: text,
            hintStyle: textStyle(screenHeight * 0.017, FontWeight.w500,
                Colors.grey.withOpacity(0.6),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.transparent, width: 1.2),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.transparent, width: 1.2),
            ),
            errorBorder: const UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.transparent, width: 1.2),
            ),
            prefixIcon:Icon(
              iconData,
              size: screenHeight*0.023,
              color: validField?Colors.grey.shade400:Colors.red,
            ) ,
            suffixIcon: suffixIcon ? IconButton(
              splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  style: IconButton.styleFrom(surfaceTintColor: Colors.transparent,backgroundColor: Colors.transparent),
                  onPressed: onPressed,
                  icon: Icon(
                      visibility?CupertinoIcons.eye_slash:CupertinoIcons.eye,
                      color: Colors.grey.withOpacity(0.6),
                      size: screenHeight*0.023,
                    ),
                )
                : null,
          ),
          onChanged: func,
        ),
      );
  }
}

class ContButton extends StatelessWidget {
  const ContButton({
    super.key,
    required this.func,
    required this.txt,
    required this.bgColor,
    required this.txtColor, required this.showLoader,
  });
  final Function() func;
  final String txt;
  final Color bgColor;
  final Color txtColor;
  final bool showLoader;
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.sizeOf(context).height;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        disabledForegroundColor: Colors.black,
        foregroundColor: CupertinoColors.black,
        surfaceTintColor: CupertinoColors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        backgroundColor: bgColor,
      ),
      onPressed: func,
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.07,
        child: Center(
          child: showLoader?SpinKitFadingCircle(
            itemBuilder: (BuildContext context, int index) => const DecoratedBox(decoration: BoxDecoration(
              color: CupertinoColors.white,
              shape: BoxShape.circle
            )),
          ) : Text(
            txt,
            style: textStyle(screenHeight * 0.023, FontWeight.w600, txtColor),
          ),
        ),
      ),
    );
  }
}

class BottomPageButton extends StatelessWidget {
  const BottomPageButton({
    super.key,
    required this.text,
    required this.func,
    required this.bgColor,
    required this.textStyle,
  });
  final String text;
  final Function() func;
  final Color bgColor;
  final TextStyle textStyle;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height / 12,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            surfaceTintColor: bgColor,
            foregroundColor: bgColor,
            splashFactory: NoSplash.splashFactory,
            side: const BorderSide(color: Colors.black, width: 2.0),
            backgroundColor: bgColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
            )),
        onPressed: func,
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    );
  }
}
