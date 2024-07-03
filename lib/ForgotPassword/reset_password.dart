import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tag_book/auth/screen/login/log_in.dart';
import 'package:tag_book/intro_page.dart';
import '../auth/data/Fetch_ApiData/fetch_apidata.dart';
import '../auth/func/validate_authdata/validate_authdata.dart';
import '../common/styles/styles.dart';
import '../common/widgets/custom_fields_and_button.dart';


class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key, required this.userID, required this.signedIn});
  final bool signedIn;
  final String userID;
  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController passKeyController = TextEditingController();
  TextEditingController rePassKeyController = TextEditingController();


  @override
  void dispose() {
    super.dispose();
    showLoader = false;
    passKeyController.dispose();
    rePassKeyController.dispose();
  }
  bool visibleField = true;
  bool visibleField1 = true;
  bool showLoader  = false;
  @override
  Widget build(BuildContext context) {
    bool validPass = Provider.of<UserValidator>(context).validPassKey;
    bool validRePass = Provider.of<UserValidator>(context).validRePassKey;
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  //Image.asset(''),
                  Title(
                    color: Colors.black,
                    child: Text(
                      'My Tag Book',
                      style: textStyle(
                          screenHeight * 0.037, FontWeight.bold, Colors.black,
                      ),
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
                        "Password",
                        style: textStyle(
                            screenHeight * 0.02, FontWeight.w400, Colors.black),
                      ),
                    ),
                    validPass
                        ? const SizedBox()
                        : Expanded(
                      child: Text(
                        'Must contain a '
                            'lowercase, uppercase,'
                            ' numeric and a special symbol',
                        style: textStyle(screenHeight * 0.015,
                            FontWeight.w400, Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
              const SpacedBox(),
              CustomTextField(
                text: 'Please Enter Password',
                iconData: CupertinoIcons.phone,
                maxLen: 10,
                suffixIcon: true,
                preffixIcon: true,
                func: (value) {},
                controller: passKeyController,
                keyboardType: TextInputType.text,
                validField: validPass,
                onPressed: () {
                  setState(() {
                    visibleField = !visibleField;
                  });
                },
                visibility: visibleField,
              ),
              const SpacedBox(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "Confirm Password",
                        style: textStyle(
                            screenHeight * 0.02, FontWeight.w400, Colors.black),
                      ),
                    ),
                    validRePass
                        ? const SizedBox()
                        : Text(
                      'Passwords don\'t match',
                      style: textStyle(screenHeight * 0.015,
                          FontWeight.w400, Colors.red),
                    ),
                  ],
                ),
              ),
              const SpacedBox(),
              CustomTextField(
                text: 'Please confirm password',
                iconData: CupertinoIcons.lock,
                maxLen: 10,
                suffixIcon: true,
                preffixIcon: true,
                func: (value) {},
                controller: rePassKeyController,
                keyboardType: TextInputType.text,
                validField: validRePass,
                onPressed: () {
                  setState(() {
                    visibleField1 = !visibleField1;
                  });
                },
                visibility: visibleField1,
              ),
              const SpacedBoxLarge(),
              const SpacedBox(),
              ContButton(
                showLoader: showLoader,
                func: () async {
                  Provider.of<UserValidator>(context, listen: false).validatePassword(passKeyController.text);
                  Provider.of<UserValidator>(context, listen: false).validateRePassword(rePassKeyController.text, passKeyController.text);
                  if (Provider.of<UserValidator>(context, listen: false).validPassKey && Provider.of<UserValidator>(context, listen: false).validRePassKey)
                  {
                    setState(() {
                      showLoader = true;
                    });
                    if (await resetPassword(widget.userID, passKeyController.text) && (mounted)) {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.07,
                                vertical: screenHeight * 0.04),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: screenWidth * 0.07,
                                    ),
                                    SvgPicture.asset(
                                        'assets/images/passkey.svg'),
                                  ],
                                ),
                                const SpacedBoxBig(),
                                Text(
                                  'Please Login with new Password',
                                  style: textStyle(screenHeight * 0.016,
                                      FontWeight.w400, Colors.black),
                                ),
                                const SpacedBox(),
                                Text(
                                  'Password has been changed successfully',
                                  style: textStyle(screenHeight * 0.016,
                                      FontWeight.w400, Colors.black),
                                ),
                                const SpacedBoxBig(),
                                ContButton(
                                    showLoader: false,
                                    func: () {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                            widget.signedIn?const IntroPage():ChangeNotifierProvider(
                                                    create: (BuildContext
                                                    context) =>
                                                        UserValidator(),
                                                    child: const LogIn()),
                                          ),
                                              (route) => false);
                                    },
                                    txt: 'Okay',
                                    bgColor: Colors.black,
                                    txtColor: CupertinoColors.white)
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      setState(() {
                        showLoader = false;
                      });
                    }
                  }
                },
                txt: 'Continue',
                bgColor: Colors.black,
                txtColor: CupertinoColors.white,
              ),
              Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                      surfaceTintColor: Colors.transparent,
                      shadowColor: Colors.transparent),
                  onPressed: () {
                    widget.signedIn?Navigator.pop(context):
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>ChangeNotifierProvider(create: (BuildContext context)=>UserValidator(),
                        child: const LogIn(),),), (route) => false);
                  },
                  child: Text(
                    'cancel',
                    style: textStyle(screenHeight * 0.016, FontWeight.w500,
                        Colors.grey.shade400),
                  ),
                ),
              ),
              const Spacer(),
              Image.asset('assets/images/changePass.png'),
            ],
          ),
        ),
      ),
    );
  }
}
