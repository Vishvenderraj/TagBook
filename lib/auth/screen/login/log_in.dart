import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tag_book/auth/screen/signup/sign_up.dart';
import 'package:tag_book/root/user_tag_page.dart';
import '../../../ForgotPassword/forgot_password.dart';
import '../../../Menu/MyTags/wigdets/fetch_tags.dart';
import '../../../common/styles/styles.dart';
import '../../../common/widgets/custom_fields_and_button.dart';
import '../../../root/intro_page.dart';
import '../../data/Fetch_ApiData/fetch_apidata.dart';
import '../../func/validate_authdata/validate_authdata.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController mobileEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();

  @override
  void initState() {
    mobileEditingController.clear();
    passwordEditingController.clear();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    mobileEditingController.dispose();
    passwordEditingController.dispose();
  }

  bool visibleField = true;
  bool showLoader = false;
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CupertinoColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.03,
                  left: screenWidth * 0.08,
                  right: screenWidth * 0.08),
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
                          style: textStyle(screenHeight * 0.035,
                              FontWeight.bold, Colors.black),
                        ),
                      ),
                    ],
                  ),
                  const SpacedBoxBig(),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Phone Number",
                            style: textStyle(screenHeight * 0.02,
                                FontWeight.w400, Colors.black),
                          ),
                        ),
                        Provider.of<UserValidator>(context).validUserId
                            ? const SizedBox()
                            : Text(
                                mobileEditingController.text.isEmpty?'no credentials found':'Invalid Credentials',
                                style: textStyle(screenHeight * 0.015,
                                    FontWeight.w400, Colors.red),
                              ),
                      ],
                    ),
                  ),
                  const SpacedBox(),
                  CustomTextField(
                    text: 'Enter Phone Number',
                    iconData: CupertinoIcons.phone,
                    maxLen: 10,
                    suffixIcon: false,
                    preffixIcon: true,
                    func: (value) {},
                    controller: mobileEditingController,
                    keyboardType: TextInputType.phone,
                    validField: Provider.of<UserValidator>(context).validUserId,
                    onPressed: () {},
                    visibility: false,
                  ),
                  const SpacedBox(),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                    child: Text(
                      "Password",
                      style: textStyle(
                          screenHeight * 0.02, FontWeight.w400, Colors.black),
                    ),
                  ),
                  const SpacedBox(),
                  CustomTextField(
                    text: 'Enter Password',
                    iconData: CupertinoIcons.lock,
                    maxLen: 10,
                    suffixIcon: true,
                    preffixIcon: true,
                    func: (value) {},
                    controller: passwordEditingController,
                    keyboardType: TextInputType.text,
                    validField: Provider.of<UserValidator>(context).validPassKey,
                    onPressed: () {
                      setState(() {
                        visibleField = !visibleField;
                      });
                    },
                    visibility: visibleField,
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ChangeNotifierProvider(
                              create: (BuildContext context) =>
                                  UserValidator(),
                              child: const ForgotPassword(),);
                          },
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth*0.05, vertical: screenHeight*0.012),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          'Forgot Password?',
                          style: textStyle(screenHeight * 0.017, FontWeight.w700,
                              Colors.lightBlue),
                        ),
                      ),
                    ),
                  ),
                  const SpacedBoxBig(),
                  ContButton(
                    showLoader: showLoader,
                    func: () async {
                      Provider.of<UserValidator>(context, listen: false).validateUserID(mobileEditingController.text);
                      if(Provider.of<UserValidator>(context, listen: false).validUserId && passwordEditingController.text.isNotEmpty)
                     {
                       setState(() {
                         showLoader = true;
                       });
                       Provider.of<UserValidator>(context, listen: false).validateValues();
                       if (await logInSignup(mobileEditingController.text, passwordEditingController.text, "login",)) {
                         await fetchUserData();
                         await getAllTag();
                         if(!mounted) return;
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => tags.isEmpty?const IntroPage():const UserTagPage(),
                      ),(route)=>false);
                      }
                      else
                      {
                        if(!mounted) return;
                        Provider.of<UserValidator>(context, listen: false).inValidateValues();
                        setState(() {
                          showLoader = false;
                        });
                      }
                     }
                      else
                        {
                          Provider.of<UserValidator>(context, listen: false).inValidateValues();
                          setState(() {
                            showLoader = false;
                          });
                        }
                    },
                    txt: 'Continue',
                    bgColor: Colors.black,
                    txtColor: CupertinoColors.white,
                  ),
                ],
              ),
            ),
            const SpacedBoxLarge(),
            SizedBox(
              height: screenHeight * 0.28,
              width: screenWidth,
              child: SvgPicture.asset(
                'assets/images/login.svg',
                fit: BoxFit.scaleDown,
                width: screenWidth * 0.7,
              ),
            ),
            const Spacer(),
            Text(
              'Don\'t have account?',
              style: textStyle(
                  screenHeight * 0.017, FontWeight.w400, Colors.black),
            ),
            SizedBox(height: screenHeight * 0.02),
            BottomPageButton(
              text: 'Sign Up',
              func: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 1000),
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        ChangeNotifierProvider(
                      create: (BuildContext context) => UserValidator(),
                      child: const SignUp(),
                    ),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(0.0, 1.0);
                      const end = Offset.zero;
                      const curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end).chain(
                        CurveTween(curve: curve),
                      );

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ),
                );
              },
              bgColor: CupertinoColors.white,
              textStyle: textStyle(20, FontWeight.bold, Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
