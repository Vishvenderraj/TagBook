import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/data/Fetch_ApiData/fetch_apidata.dart';
import '../auth/func/validate_authdata/validate_authdata.dart';
import '../auth/screen/otp/otp_page.dart';
import '../common/styles/styles.dart';
import '../common/widgets/custom_fields_and_button.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  bool isUserExist = true;
  bool showLoader = false;
  TextEditingController mobileEditingController = TextEditingController();

  @override
  void dispose() {
    mobileEditingController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    bool validateMobile = Provider.of<UserValidator>(context).validUserId;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
              top: screenHeight * 0.03,
              left: screenWidth * 0.08,
              right: screenWidth * 0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'My Tag Book',
                    style: textStyle(
                        screenHeight * 0.035, FontWeight.bold, Colors.black),
                  ),
                ],
              ),
              const SpacedBoxBig(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Phone Number",
                      style: textStyle(
                          screenHeight * 0.02, FontWeight.w400, Colors.black),
                    ),
                    validateMobile
                        ? isUserExist? const SizedBox():Text(
                      'User not found',
                      style: textStyle(screenHeight * 0.015,
                          FontWeight.w400, Colors.red),
                    ): Text(
                            'Please enter valid phone number',
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
                validField: validateMobile?isUserExist:validateMobile,
                onPressed: () {  },
                visibility: false,
              ),
              const SpacedBoxLarge(),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.001,
              ),
              ContButton(
                showLoader: showLoader,
                func: () async {
                  Provider.of<UserValidator>(context, listen: false).validateUserID(mobileEditingController.text);
                  if (Provider.of<UserValidator>(context, listen: false).validUserId) {
                    setState(() {
                      showLoader = true;
                      isUserExist = true;
                    });
                    if (await checkUserData(mobileEditingController.text) && (mounted)){
                        setState(() {
                          showLoader = false;
                          isUserExist = true;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OTPage(
                              fromResetPass: true,
                              userID: mobileEditingController.text,
                              userPassKey: '',
                            ),
                          ),
                        );

                    }else{
                      setState(() {
                        showLoader = false;
                          isUserExist = false;
                      });
                    }
                  }
                },
                txt: 'Continue',
                bgColor: Colors.black,
                txtColor: Colors.white,
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
