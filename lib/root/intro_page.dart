import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tag_book/Menu/MyTags/wigdets/fetch_tagicons.dart';
import 'package:tag_book/Menu/Profile/my_profile.dart';
import 'package:tag_book/postTags/MainPage/my_tagbook.dart';
import '../Menu/MyTags/EditTags/create_edit_tags.dart';
import '../Menu/menu.dart';
import '../common/styles/styles.dart';
import '../common/widgets/custom_fields_and_button.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 6,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: screenHeight * 0.03,
                    left: screenWidth * 0.08,
                    right: screenWidth * 0.08,
                  ),
                  child: SizedBox(
                    height: screenHeight / 1.1,
                    width: screenWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChangeNotifierProvider(
                                    create: (context) => Counter(),
                                    child: const Menu(),
                                  ),
                                ),
                              );
                            },
                            child: Image.asset(
                              'assets/images/IntroButton.png',
                              height: screenHeight * 0.04,
                            ),
                          ),
                        ),
                        const SpacedBoxBig(),
                        Center(
                          child: SizedBox(
                              height: screenHeight * 0.25,
                              child: Image.asset('assets/images/image 2.png')),
                        ),
                        Title(
                          color: Colors.black,
                          child: Text(
                            'My Tag Book',
                            softWrap: true,
                            style: TextStyle(
                              fontSize: screenHeight * 0.034,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          "last updated: No records",
                          softWrap: true,
                          style: textStyle(screenHeight * 0.017,
                              FontWeight.w700, Colors.grey.shade500),
                        ),
                        const SpacedBoxBig(),
                        Text(
                          'Hi there! I\'m for keeping all your important links and texts tagged in one place, ready whenever you need them.',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: screenHeight * 0.017,
                          ),
                        ),
                        Text(
                          '\nSave that YouTube video to watch later or keep that Snapchat link handy. Tag your links so you can easily find them for creating things, shopping, exercising, or making memes.',
                          softWrap: true,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: screenHeight * 0.017,
                          ),
                        ),
                        Text(
                          '\nI\'m here to help you stay organized and efficient!',
                          softWrap: true,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: screenHeight * 0.017,
                          ),
                        ),
                        const SpacedBox(),
                        GestureDetector(
                          onTap: () async {
                            final pref = await SharedPreferences.getInstance();
                            if (!mounted) return;
                            Navigator.push(context,
                              MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                  create: (BuildContext context) => Tapped(true),
                                  child: MyProfile(
                                    userID: '${pref.getString("userID")}',
                                    regDates: '${pref.getString("regDate")}',
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Text(
                            "View: Future",
                            style: textStyle(screenHeight * 0.017,
                                FontWeight.w800, Colors.lightBlue),
                          ),
                        ),
                        const SpacedBoxLarge(),
                        Text(
                          "My Tags",
                          style: textStyle(screenHeight * 0.03, FontWeight.w800,
                              Colors.black),
                        ),
                        const SpacedBoxBig(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: ()  {
                                  showModalBottomSheet(
                                  enableDrag: false,
                                  isScrollControlled: false,
                                  isDismissible: true,
                                  backgroundColor: Colors.white,
                                  context: context,
                                  builder: (context) => GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>EditTags(addTag: true, iconLists: iconList),),);
                                    },
                                    child: Container(
                                      height: screenHeight/2,
                                      width: screenWidth,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.01,
                                          vertical: screenHeight * 0.028,
                                        ),
                                        child: SingleChildScrollView(
                                          child: SizedBox(
                                            height: screenHeight,
                                            child: EditTags(
                                              addTag: true,
                                              iconLists: iconList,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: screenHeight * 0.09,
                                width: screenWidth * 0.195,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: CupertinoColors.white,
                                  border:
                                      Border.all(color: Colors.grey.shade200),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade400,
                                      spreadRadius: 1.0,
                                      blurRadius: 2,
                                      offset: const Offset(0, 5),
                                    )
                                  ],
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                      'assets/images/Vector.svg'),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    EdgeInsets.only(left: screenWidth * 0.1),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Create your first tag !!",
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: screenHeight * 0.018,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          height: 0),
                                    ),
                                    const SpacedBox(),
                                    Text(
                                      "These tags will help you organize your links into different categories so you can easily find them later.",
                                      softWrap: true,
                                      style: textStyle(screenHeight * 0.015,
                                          FontWeight.w400, Colors.black),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SpacedBoxBig(),
              BottomPageButton(
                text: "Add To Tag Book",
                func: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ChangeNotifierProvider(create: (BuildContext context) { return Tapped(false); },
                  child: const MyTagBook()),
                  ),);
                },
                bgColor: Colors.black,
                textStyle: textStyle(20, FontWeight.w700, Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
