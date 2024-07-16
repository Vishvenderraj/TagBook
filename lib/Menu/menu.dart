import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tag_book/ForgotPassword/confirm_oldpassword.dart';
import 'package:tag_book/Menu/MyTags/my_tags.dart';
import 'package:tag_book/Menu/MyTags/wigdets/fetch_tags.dart';
import 'package:tag_book/Menu/MyTags/wigdets/provider_icos.dart';
import 'package:tag_book/auth/data/Fetch_ApiData/fetch_apidata.dart';
import 'package:tag_book/policies/terms&conditions/terms_n_conditions.dart';
import '../auth/func/validate_authdata/validate_authdata.dart';
import '../common/styles/styles.dart';
import '../common/widgets/custom_fields_and_button.dart';
import '../common/widgets/form_page.dart';
import 'Profile/my_profile.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;
    bool pressed = Provider.of<Counter>(context).isPressed;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
              top: screenHeight * 0.03,
              left: screenWidth * 0.08,
              right: screenWidth * 0.08),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Menu',
                        style: TextStyle(
                          fontSize: screenHeight * 0.037,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.007),
                        child: Text(
                          'hope you find what you looking for',
                          softWrap: true,
                          style: textStyle(screenHeight * 0.017,
                              FontWeight.w500, Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Material(
                      elevation: 6,
                      borderRadius: BorderRadius.circular(60),
                      child: const CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.black,
                        child: Icon(
                          CupertinoIcons.xmark,
                          color: CupertinoColors.white,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SpacedBoxLarge(),
              MenuOptions(
                screenHeight: screenHeight,
                title: 'My Profile',
                bgColor: Colors.blue,
                image: 'assets/images/menu1.svg',
                onTap: () async{
                  final pref = await SharedPreferences.getInstance();
                  if(!mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                        create: (context) => Tapped(false),
                        child:  MyProfile(userID: '${pref.getString("userID")}', regDates: '${pref.getString("regDate")}',),
                      ),
                    ),
                  );
                },
                iconData: Icons.arrow_forward_ios,
                needInnerCircle: false,
              ),
              GestureDetector(
                onTap: () {
                  Provider.of<Counter>(context, listen: false).change();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.008),
                  child: Material(
                    elevation: pressed ? 5 : 0,
                    shadowColor: Colors.black,
                    borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(30),
                        topRight: const Radius.circular(30),
                        bottomLeft: Radius.circular(pressed ? 20 : 30),
                        bottomRight: Radius.circular(pressed ? 20 : 30),),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.green,
                                  child: Center(
                                    child: SvgPicture.asset(
                                        'assets/images/menu3.svg'),
                                  ),
                                ),
                                title: Text(
                                      'Security',
                                  style: textStyle(screenHeight * 0.018,
                                      FontWeight.bold, Colors.black),
                                ),
                                trailing: Icon(
                                  pressed
                                      ? CupertinoIcons.chevron_up
                                      : Icons.arrow_forward_ios,
                                  color: Colors.grey.shade500,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        pressed
                            ? SizedBox(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context, (MaterialPageRoute(
                                            builder: (context) =>
                                                const ConfirmOldPassword(),
                                          )),
                                        );
                                      },
                                      child: ListTile(
                                        leading: const CircleAvatar(
                                          backgroundColor: Colors.green,
                                          child: Icon(
                                            Icons.more_horiz_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                        title: Text(
                                          'Change Pass-Code',
                                          style: textStyle(screenHeight * 0.018,
                                              FontWeight.bold, Colors.black),
                                        ),
                                      ),
                                    ),
                                    const Divider(
                                      thickness: 0.5,
                                    ),
                                    GestureDetector(
                                      onTap: ()async{
                                        await getPolicies(type:'privacyAndPolicy');
                                        if(!mounted) return;
                                        getSubtitle.isNotEmpty && terms.isNotEmpty? Navigator.push(context, MaterialPageRoute(builder: (context)=>const TermsAndConditions()),):null;
                                      },
                                      child: ListTile(
                                        selectedTileColor: Colors.transparent,
                                         hoverColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.green,
                                            child: SvgPicture.asset(
                                                'assets/images/security.svg',
                                            ),
                                          ),
                                          title: Text(
                                            'Privacy Policies',
                                            style: textStyle(screenHeight * 0.018,
                                                FontWeight.bold, Colors.black),
                                          ),),
                                    ),
                                    const Divider(
                                      thickness: 0.5,
                                    ),
                                    GestureDetector(
                                      onTap: ()async{
                                        await getPolicies(type:'termsAndConditions');
                                        if(!mounted) return;
                                        getSubtitle.isNotEmpty && terms.isNotEmpty? Navigator.push(context, MaterialPageRoute(builder: (context)=>const TermsAndConditions()),):null;
                                      },
                                      child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.green,
                                            child: SvgPicture.asset(
                                                'assets/images/security.svg'),
                                          ),
                                          title: Text(
                                            'Terms and Conditions',
                                            style: textStyle(screenHeight * 0.018,
                                                FontWeight.bold, Colors.black),
                                          ),),
                                    ),
                                    const SpacedBox(),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
              !pressed
                  ? MenuOptions(
                      screenHeight: screenHeight,
                      title: 'My Tags',
                      bgColor: Colors.yellow,
                      image: 'assets/images/menu2.svg',
                      onTap: () async{
                        if(tags.isEmpty)
                        {
                            tags =  await getAllTag();
                        }
                        if(!mounted) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider(create: (BuildContext context) => IconProvider(),
                            child: MyTags(allTags: tags,),),
                          ),
                        );
                      },
                      iconData: Icons.arrow_forward_ios,
                      needInnerCircle: false,
                    )
                  : const SizedBox(),
              !pressed
                  ? MenuOptions(
                      screenHeight: screenHeight,
                      title: 'Report Bug',
                      bgColor: Colors.red,
                      image: 'assets/images/menu4.svg',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FeedBack(
                                title: 'Report Bug',
                                subtitle:
                                    'we appreciate your support: Thank you', type: 'reportBugs',),
                          ),
                        );
                      },
                      iconData: Icons.arrow_forward_ios,
                      needInnerCircle: false,
                    ) : const SizedBox(),
              const SpacedBoxBig(),
              ContButton(
                showLoader: false,
                func: () {
                  logout(context);
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                txt: 'Logout',
                bgColor: Colors.black,
                txtColor: CupertinoColors.white,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  disabledForegroundColor: CupertinoColors.white,
                  foregroundColor: CupertinoColors.white
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const FeedBack(title: 'Request Features', subtitle: 'we appreciate your ideas and suggestions', type: 'requestFeatures',),),);
                },
                child: Text(
                  "request features",
                  style: textStyle(screenHeight * 0.015, FontWeight.w700,
                      Colors.grey.shade400),
                ),
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.03),
                child: Text(
                  "version 0.01",
                  style: textStyle(screenHeight * 0.016, FontWeight.w600,
                      Colors.grey.shade400),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MenuOptions extends StatelessWidget {
  const MenuOptions({
    super.key,
    required this.screenHeight,
    required this.title,
    required this.bgColor,
    required this.image,
    required this.onTap,
    required this.iconData,
    required this.needInnerCircle,
  });

  final double screenHeight;
  final String title;
  final Color bgColor;
  final String image;
  final IconData iconData;
  final bool needInnerCircle;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.008),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(30)),
          child: ListTile(
            leading: Container(
              height: screenHeight * 0.09,
              width: screenWidth * 0.09,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: needInnerCircle
                    ? Border.all(color: Colors.grey.shade300)
                    : null,
                color: bgColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  image,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            title: Text(
              title,
              style: textStyle(
                  screenHeight * 0.018, FontWeight.bold, Colors.black),
            ),
            trailing: Icon(
              iconData,
              color: Colors.grey.shade500,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
