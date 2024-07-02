import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:tag_book/ForgotPassword/reset_password.dart';
import '../../../common/styles/styles.dart';
import '../../../common/widgets/custom_fields_and_button.dart';
import '../../data/Fetch_ApiData/fetch_apidata.dart';
import '../../data/Fetch_FirebaseAuth/firebase_auth.dart';
import '../../func/validate_authdata/validate_authdata.dart';
import '../../../intro_page.dart';

class OTPage extends StatefulWidget {
  const OTPage(
      {super.key,
      required this.fromResetPass,
      required this.userID,
      required this.userPassKey});

  final bool fromResetPass;
  final String userID;
  final String userPassKey;

  @override
  State<OTPage> createState() => _OTPageState();
}

class _OTPageState extends State<OTPage> {
  Duration sec = const Duration(seconds: 60);
  Timer? timer;
  bool showLoader = false;
  bool isValidOtp = true;
  String? verification = '';
  TextEditingController pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    phoneVerification(
      widget.userID,
      (String verificationId, int? resendToken) {
        verification = verificationId;
      },
    );
    startTimer();
  }

  void zeroTimer() {
    setState(() {
      if (sec.inSeconds > 0) {
        sec = Duration(seconds: sec.inSeconds - 1);
      } else {
        timer?.cancel();
      }
    });
  }

  void startTimer() {
    timer?.cancel(); // Cancel any existing timer
    setState(() {
      sec = const Duration(seconds: 60);
    });
    timer = Timer.periodic(const Duration(seconds: 1), (timer) => zeroTimer());
  }

  Future<void> signInUser() async {
    if (await logInSignup(widget.userID, widget.userPassKey, "signup") &&
        (mounted)) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (BuildContext context) => UserValidator(),
            child: const IntroPage(),
          ),
        ),
        (route) => false,
      );
    }
  }

  void toResetPass() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (BuildContext context) => UserValidator(),
          child: ResetPassword(userID: widget.userID),
        ),
      ),
      (route) => false,
    );
  }

  @override
  void dispose() {
    pinController.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CupertinoColors.white,
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
                          screenHeight * 0.037, FontWeight.bold, Colors.black),
                    ),
                  ),
                ],
              ),
              const SpacedBoxBig(),
              Text(
                "OTP Verification",
                style: textStyle(
                    screenHeight * 0.020, FontWeight.w800, Colors.black),
              ),
              const SpacedBox(),
              Text(
                "please enter OTP sent to your registered phone number",
                style: textStyle(
                    screenHeight * 0.017, FontWeight.w400, Colors.grey),
              ),
              const SpacedBoxBig(),
              Pinput(
                length: 6,
                controller: pinController,
                defaultPinTheme: PinTheme(
                  width: 50,
                  height: 63,
                  textStyle: const TextStyle(
                      fontSize: 28,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: isValidOtp ? Colors.grey.shade300 : Colors.red),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                pinputAutovalidateMode: PinputAutovalidateMode.disabled,
                errorTextStyle: textStyle(15, FontWeight.w400, Colors.red),
              ),
              const SpacedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  isValidOtp
                      ? const SizedBox()
                      : Text(
                          'Entered wrong OTP',
                          style: textStyle(screenHeight * 0.017,
                              FontWeight.w400, Colors.red),
                        ),
                  GestureDetector(
                    onTap: () async {
                      try {
                        phoneVerification(widget.userID,
                            (String verificationId, int? resendToken) {
                          setState(() {
                            startTimer();
                            pinController.clear();
                          });
                        });
                      } catch (e) {
                        debugPrint(e.toString());
                      }
                    },
                    child: Text(
                      sec.inSeconds == 0
                          ? "resend it"
                          : (sec.inSeconds > 9
                              ? "00.${sec.inSeconds}"
                              : "00.0${sec.inSeconds}"),
                      style: textStyle(
                          screenHeight * 0.017, FontWeight.w500, Colors.blue),
                    ),
                  ),
                ],
              ),
              const SpacedBoxBig(),
              ContButton(
                showLoader: showLoader,
                func: () async {
                  if (pinController.text.isNotEmpty ||
                      pinController.text.length == 6) {
                    try {
                      setState(() {
                        showLoader = true;
                      });
                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                              verificationId: verification!,
                              smsCode: pinController.text);
                      // Sign the user in (or link) with the credential
                      widget.fromResetPass
                          ? await auth.signInWithCredential(credential)
                          : null;
                      widget.fromResetPass ? toResetPass() : signInUser();
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'invalid-verification-code') {
                        setState(() {
                          showLoader = false;
                          isValidOtp = false;
                        });
                      } else {
                        debugPrint(e.toString());
                      }
                    }
                  } else {
                    setState(() {
                      showLoader = false;
                      isValidOtp = false;
                    });
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
                    Navigator.pop(context);
                  },
                  child: Text(
                    'cancel',
                    style: textStyle(screenHeight * 0.015, FontWeight.w500,
                        Colors.grey.shade400),
                  ),
                ),
              ),
              const Spacer(),
              Expanded(
                flex: 3,
                child: Center(
                  child: SvgPicture.asset(isValidOtp
                      ? 'assets/images/otpscreen.svg'
                      : 'assets/images/invalidotpscreen.svg'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
