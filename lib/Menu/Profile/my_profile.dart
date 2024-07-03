import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../auth/data/Fetch_ApiData/fetch_apidata.dart';
import '../../common/styles/styles.dart';
import '../../common/widgets/form_page.dart';
import '../R_Response/r_respone.dart';
import '../menu.dart';


class MyProfile extends StatelessWidget {
  const MyProfile({super.key});


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Profile',
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
                          'This is about you only',
                          softWrap: true,
                          style: textStyle(screenHeight * 0.017,
                              FontWeight.w500, Colors.grey),
                        ),
                      ),
                      Text(
                        " $userId : Registered on (${registeredDate?.substring(0,10)})",
                        softWrap: true,
                        style: textStyle(screenHeight * 0.017, FontWeight.w400,
                            Colors.black),
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
                      child: CircleAvatar(
                        radius: screenHeight * 0.029,
                        backgroundColor: Colors.black,
                        child: const Icon(
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
              SizedBox(
                height: screenHeight * 0.25,
                width: screenWidth,
                child: Column(
                  children: [
                    Expanded(
                      child: MenuOptions(
                        screenHeight: screenHeight,
                        title: 'Submit your feedback',
                        bgColor: Colors.blue,
                        image: 'assets/images/MymenuIcon1.svg',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FeedBack(
                                title: 'Feedback',
                                subtitle:
                                    'thank you for using this application',
                              ),
                            ),
                          );
                        },
                        iconData: Icons.arrow_forward_ios,
                        needInnerCircle: false,
                      ),
                    ),
                    Expanded(
                      child: MenuOptions(
                        screenHeight: screenHeight,
                        title: 'View requests and response',
                        bgColor: Colors.blue,
                        image: 'assets/images/MymenuIcon2.svg',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RResponse(),),
                          );
                        },
                        iconData: Icons.arrow_forward_ios,
                        needInnerCircle: false,
                      ),
                    ),
                    Expanded(
                      child: MenuOptions(
                        screenHeight: screenHeight,
                        title: 'View Future',
                        bgColor: Colors.blue,
                        image: 'assets/images/MymenuIcon3.svg',
                        onTap: () {
                          Provider.of<Tapped>(context,listen: false).tapped();
                        },
                        iconData: Provider.of<Tapped>(context).isTapped?CupertinoIcons.eye:CupertinoIcons.eye_slash,
                        needInnerCircle: false,
                      ),
                    ),
                  ],
                ),
              ),
              Provider.of<Tapped>(context).isTapped?
              SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SpacedBoxLarge(),
                    SvgPicture.asset('assets/images/Line 3.svg'),
                    const SpacedBoxLarge(),
                    Text(
                      "Future:",
                      style: textStyle(
                          screenHeight * 0.02, FontWeight.w800, Colors.lightBlue),
                    ),
                    Text(
                      'The Upcoming Features and News',
                      style: textStyle(
                          screenHeight * 0.016, FontWeight.w400, Colors.black),
                    ),
                    const SpacedBoxBig(),
                    Text(
                      "Features:",
                      style: textStyle(
                          screenHeight * 0.016, FontWeight.w400, Colors.lightBlue),
                    ),
                    const BulletPoints(text: 'Home Page Revamp and more usable'),
                    const BulletPoints(text: 'Explore and Follow other Tag Books'),
                    const BulletPoints(text: 'Can monetize your Tag Books'),
                    const BulletPoints(
                        text:
                        'Can view the analytical report for the performance of the Tag Books created'),
                    const BulletPoints(
                      text: 'Can Sponsor your Add Book on Explore Page',
                    ),
                    const SpacedBoxBig(),
                    Text(
                      "News:",
                      style: textStyle(
                          screenHeight * 0.016, FontWeight.w400, Colors.lightBlue),
                    ),
                    const BulletPoints(
                        text:
                        'Next update will be after 2 months as dev team is going on a small break'),
                    const BulletPoints(
                        text: 'Working with Payment Gateway Providers'),
                    const BulletPoints(
                        text:
                        'Seems we can raise funding in next 5 months as soon as we achieve the target of 1 Lakh active users'),
                  ],
                ),
              ) :
              const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}

class BulletPoints extends StatelessWidget {
  final String text;
  const BulletPoints({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.sizeOf(context).height;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 0,
          child: Text(
            '\u2022',
            style: TextStyle(fontSize: screenHeight * 0.016),
          ),
        ),
        const SizedBox(
          width: 2,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: Text(
              text,
              style: textStyle(
                  screenHeight * 0.016, FontWeight.w400, Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
