import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tag_book/Menu/MyTags/EditTags/create_edit_tags.dart';
import 'package:tag_book/Menu/MyTags/wigdets/fetch_tagicons.dart';
import 'package:tag_book/Menu/MyTags/wigdets/fetch_tags.dart';
import 'package:tag_book/Menu/MyTags/wigdets/provider_icos.dart';
import '../../common/styles/styles.dart';

class MyTags extends StatefulWidget {
  const MyTags({super.key});

  @override
  State<MyTags> createState() => _MyTagsState();
}

class _MyTagsState extends State<MyTags> {
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
            right: screenWidth * 0.08,
          ),
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
                        'My Tags',
                        style: TextStyle(
                          fontSize: screenHeight * 0.037,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.005),
                        child: Text(
                          'manage your tags',
                          softWrap: true,
                          style: textStyle(
                            screenHeight * 0.017,
                            FontWeight.w500,
                            Colors.grey,
                          ),
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
              Expanded(
                child: ListView.builder(
                  itemCount: tags.length,
                  itemBuilder: (context, index) => SelectedTags(
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                    tagID: tags[index].tagID,
                    image: tags[index].iconImage,
                    title: tags[index].tagName,
                    func: () async {
                      if (!mounted) return;
                      Provider.of<IconProvider>(context,listen: false).selectTag(tags[index].iconID);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MultiProvider(
                            providers: [
                              ChangeNotifierProvider(
                                create: (context) =>
                                    IconProvider(),
                              ),
                              ChangeNotifierProvider(
                                create: (context) =>
                                    TagEditProvider(),
                              ),
                            ],
                            child: EditTags(
                              addTag: false,
                              tagID: tags[index].tagID,
                              iconID: tags[index].iconID,
                              tagDescr: tags[index].descr,
                              tagName: tags[index].tagName,
                              iconLists: iconList,
                            ),
                          ),
                        ),
                      );
                    }, isOnline: true,
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

class SelectedTags extends StatelessWidget {
  const SelectedTags({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.image,
    required this.title,
    required this.func,
    required this.tagID,
    required this.isOnline,
  });

  final double screenHeight;
  final double screenWidth;
  final String tagID;
  final String image;
  final String title;
  final Function()? func;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: screenHeight * 0.008),
      child: GestureDetector(
        onTap: func,
        child: Container(
          height: screenHeight * 0.065,
          width: screenWidth,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.grey.shade300),
          ),
          child: Padding(
            padding: EdgeInsets.only(
                right: screenWidth * 0.05, left: screenWidth * 0.02),
            child: Row(
              children: [
                Container(
                  height: screenHeight * 0.09,
                  width: screenWidth * 0.09,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: isOnline?SvgPicture.network(image, fit: BoxFit.contain):SvgPicture.asset(image,fit: BoxFit.contain,),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Text(
                  title,
                  style: textStyle(screenHeight * 0.016, FontWeight.w900,
                      Colors.grey.shade500),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
