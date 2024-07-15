import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tag_book/auth/screen/login/log_in.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tag_book/policies/terms&conditions/terms_n_conditions.dart';
import '../../../common/styles/styles.dart';
import '../../../common/widgets/custom_fields_and_button.dart';
import '../../data/Fetch_ApiData/fetch_apidata.dart';
import '../../func/validate_authdata/validate_authdata.dart';
import '../otp/otp_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController mobileEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController rePasswordEditingController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    mobileEditingController.dispose();
    passwordEditingController.dispose();
    rePasswordEditingController.dispose();
  }

  bool visibleField1 = true;
  bool visibleField2 = true;
  bool userExist = false;
  bool showLoader = false;
  @override
  Widget build(BuildContext context) {
    bool validMobile = Provider.of<UserValidator>(context).validUserId;
    bool validPassword = Provider.of<UserValidator>(context).validPassKey;
    bool validConfirmPassword =
        Provider.of<UserValidator>(context).validRePassKey;

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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Image.asset(''),
                      Title(
                        color: Colors.black,
                        child: Text(
                          'My Tag Book',
                          style: textStyle(screenHeight * 0.037,
                              FontWeight.bold, Colors.black),
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
                            "Phone Number",
                            style: textStyle(screenHeight * 0.02,
                                FontWeight.w400, Colors.black),
                          ),
                        ),
                        userExist
                            ? Text(
                                'User already exists',
                                style: textStyle(screenHeight * 0.017,
                                    FontWeight.w400, Colors.red),
                              )
                            : validMobile
                                ? const SizedBox()
                                : Text(
                                    'Enter valid phone number',
                                    style: textStyle(screenHeight * 0.015,
                                        FontWeight.w400, Colors.red),
                                  )
                      ],
                    ),
                  ),
                  const SpacedBox(),
                  CustomTextField(
                    text: 'Enter phone number',
                    iconData: CupertinoIcons.phone,
                    maxLen: 10,
                    suffixIcon: false,
                    preffixIcon: true,
                    func: (value) {},
                    controller: mobileEditingController,
                    keyboardType: TextInputType.phone,
                    validField: userExist ? false : validMobile,
                    onPressed: () {},
                    visibility: false,
                  ),
                  const SpacedBox(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Password",
                            style: textStyle(screenHeight * 0.02,
                                FontWeight.w400, Colors.black),
                          ),
                        ),
                        validPassword
                            ? const SizedBox()
                            : Expanded(
                                child: Text(
                                  textDirection: TextDirection.rtl,
                                  'Min. 8 len, 1cap,1num,1special ',
                                  style: textStyle(screenHeight * 0.015,
                                      FontWeight.w400, Colors.red),
                                ),
                              ),
                      ],
                    ),
                  ),
                  const SpacedBox(),
                  CustomTextField(
                    text: 'Please enter password',
                    iconData: CupertinoIcons.lock,
                    maxLen: 10,
                    suffixIcon: true,
                    preffixIcon: true,
                    func: (value) {},
                    controller: passwordEditingController,
                    keyboardType: TextInputType.text,
                    validField: validPassword,
                    onPressed: () {
                      setState(() {
                        visibleField1 = !visibleField1;
                      });
                    },
                    visibility: visibleField1,
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
                            style: textStyle(screenHeight * 0.02,
                                FontWeight.w400, Colors.black),
                          ),
                        ),
                        validConfirmPassword
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
                    controller: rePasswordEditingController,
                    keyboardType: TextInputType.text,
                    validField: validConfirmPassword,
                    onPressed: () {
                      setState(() {
                        setState(() {
                          visibleField2 = !visibleField2;
                        });
                      });
                    },
                    visibility: visibleField2,
                  ),
                  const SpacedBoxLarge(),
                  ContButton(
                    showLoader: showLoader,
                    func: () async {
                      Provider.of<UserValidator>(context, listen: false)
                          .validateUserID(mobileEditingController.text);
                      Provider.of<UserValidator>(context, listen: false)
                          .validatePassword(passwordEditingController.text);
                      Provider.of<UserValidator>(context, listen: false)
                          .validateRePassword(rePasswordEditingController.text,
                              passwordEditingController.text);

                      if (Provider.of<UserValidator>(context, listen: false)
                              .validUserId &&
                          Provider.of<UserValidator>(context, listen: false)
                              .validPassKey &&
                          Provider.of<UserValidator>(context, listen: false)
                              .validRePassKey) {
                        setState(() {
                          showLoader = true;
                        });
                        if (await checkUserData(mobileEditingController.text) &&
                            (mounted)) {
                          setState(() {
                            showLoader = false;
                            userExist = true;
                          });
                        } else {
                          setState(() {
                            showLoader = false;
                            userExist = false;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OTPage(
                                fromResetPass: false,
                                userID: mobileEditingController.text,
                                userPassKey: passwordEditingController.text,
                              ),
                            ),
                          );
                        }
                      }
                    },
                    txt: 'Continue',
                    bgColor: Colors.black,
                    txtColor: CupertinoColors.white,
                  ),
                  const SpacedBox(),
                  GestureDetector(
                    onTap: () async {
                      await getPolicies(type: 'termsAndConditions');
                      if (!mounted) return;
                      getSubtitle.isNotEmpty && terms.isNotEmpty
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const TermsAndConditions(),
                              ),
                            )
                          : null;
                    },
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'by sign up you agree to our ',
                            style: textStyle(screenHeight * 0.017,
                                FontWeight.w400, Colors.grey.shade400),
                          ),
                          Text(
                            'Terms and Conditions',
                            style: textStyle(screenHeight * 0.017,
                                FontWeight.w600, Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SpacedBoxBig(),
            Align(
                alignment: Alignment.bottomRight,
                child: SvgPicture.asset(
                  'assets/images/signupimage.svg',
                  fit: BoxFit.contain,
                )),
            const Spacer(),
            Text(
              'Have an account?',
              style: textStyle(12, FontWeight.w400, Colors.black),
            ),
            const SpacedBox(),
            BottomPageButton(
              text: 'Log In',
              func: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 1000),
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        ChangeNotifierProvider(
                            create: (BuildContext context) => UserValidator(),
                            child: const LogIn()),
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
                  (route) => false,
                );
              },
              bgColor: Colors.white,
              textStyle: textStyle(20, FontWeight.bold, Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
