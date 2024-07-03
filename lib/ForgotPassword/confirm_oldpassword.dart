import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tag_book/ForgotPassword/reset_password.dart';
import '../auth/data/Fetch_ApiData/fetch_apidata.dart';
import '../auth/func/validate_authdata/validate_authdata.dart';
import '../common/styles/styles.dart';
import '../common/widgets/custom_fields_and_button.dart';

class ConfirmOldPassword extends StatefulWidget {
  const ConfirmOldPassword({super.key});

  @override
  State<ConfirmOldPassword> createState() => _ConfirmOldPasswordState();
}

class _ConfirmOldPasswordState extends State<ConfirmOldPassword> {
  TextEditingController oldPassKey = TextEditingController();
  bool showLoader = false;
  bool validInput = true;
  bool _visible = true;
  String? userID = userId;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: screenHeight * 0.03,
            left: screenWidth * 0.08,
            right: screenWidth * 0.08,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  //Image.asset(''),
                  Text(
                    'My Tag Book',
                    style: textStyle(
                      screenHeight * 0.037,
                      FontWeight.bold,
                      Colors.black,
                    ),
                  ),
                ],
              ),
              const SpacedBoxBig(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "Confirm Old Password",
                        style: textStyle(
                            screenHeight * 0.02, FontWeight.w400, Colors.black),
                      ),
                    ),
                    validInput
                        ? const SizedBox()
                        : Text(
                      'Wrong Password',
                      style: textStyle(screenHeight * 0.015,
                          FontWeight.w400, Colors.red),
                    ),
                  ],
                ),
              ),
              const SpacedBox(),
              CustomTextField(
                text: 'Please Enter your old Password',
                iconData: CupertinoIcons.lock,
                maxLen: 10,
                suffixIcon: true,
                preffixIcon: true,
                func: (value) {},
                controller: oldPassKey,
                keyboardType: TextInputType.text,
                validField: validInput,
                onPressed: () {
                  setState(() {
                    _visible = !_visible;
                  });
                },
                visibility: _visible,
              ),
              const SpacedBoxLarge(),
              const SpacedBox(),
              ContButton(
                showLoader: showLoader,
                func: () async {
                  if (oldPassKey.text.isNotEmpty)
                  {
                    setState(() {
                      showLoader = true;
                    });
                    if (await logInSignup(userID!, oldPassKey.text,"login") && (mounted)) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChangeNotifierProvider(
                                  create: (BuildContext
                                  context) => UserValidator(),
                                  child:  ResetPassword(userID: userID!, signedIn: true,),),
                          ),
                      );
                    } else {
                      setState(() {
                        showLoader = false;
                        validInput = false;
                      });
                    }
                  }
                  else {
                    setState(() {
                      validInput = false;
                    });
                  }
                },
                txt: 'Continue',
                bgColor: Colors.black,
                txtColor: CupertinoColors.white,
              ),
              const SpacedBox(),
              Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                      surfaceTintColor: Colors.transparent,
                      shadowColor: Colors.transparent),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'cancel',
                    style: textStyle(screenHeight * 0.016, FontWeight.w500,
                        Colors.grey.shade400),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
