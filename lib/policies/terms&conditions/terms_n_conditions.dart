import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tag_book/auth/data/Fetch_ApiData/fetch_apidata.dart';
import '../../common/styles/styles.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'T.&.C',
                        style: TextStyle(
                          fontSize: screenHeight * 0.037,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.007,
                        ),
                        child: Text(
                          getSubtitle,
                          softWrap: true,
                          style: textStyle(screenHeight * 0.017,
                              FontWeight.w700, Colors.grey),
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
              const SpacedBoxBig(),
              ...terms
                  .map(
                    (part) => Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.01),
                      child: Text(
                        part,
                        textAlign: TextAlign.left,
                        style: textStyle(
                          screenHeight * 0.017,
                          FontWeight.w400,
                          Colors.grey.shade400,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              const SpacedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
