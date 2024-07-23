import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tag_book/Menu/MyTags/EditTags/create_edit_tags.dart';
import 'package:tag_book/Menu/MyTags/wigdets/provider_icos.dart';
import 'package:tag_book/common/widgets/custom_fields_and_button.dart';
import '../Menu/MyTags/wigdets/fetch_tagicons.dart';
import '../Menu/MyTags/wigdets/fetch_tags.dart';
import '../Menu/menu.dart';
import '../common/styles/styles.dart';
import '../postTags/MainPage/my_tagbook.dart';
import '../postTags/Provider/provider_tagbook.dart';

class UserTagPage extends StatefulWidget {
  const UserTagPage({super.key});

  @override
  State<UserTagPage> createState() => _UserTagPageState();
}

class _UserTagPageState extends State<UserTagPage> {
  String selectedTagID = '';
  void applyFilters() {
    filterOn = true;
    filteredPosts = posts.where((post) {
      return listOfFilterIds.contains(post.image1) ||
          listOfFilterIds.contains(post.image2) ||
          listOfFilterIds.contains(post.image3);
    }).toList();
  }

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
          child: Column(children: [
            Expanded(
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
                            child: Image.asset('assets/images/homepage.png')),
                      ),
                      const SpacedBoxBig(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Title(
                                color: Colors.black,
                                child: Row(
                                  children: [
                                    SvgPicture.asset('assets/images/tags.svg'),
                                    SizedBox(
                                      width: screenWidth * 0.02,
                                    ),
                                    Text(
                                      'NoTag',
                                      softWrap: true,
                                      style: TextStyle(
                                        fontSize: screenHeight * 0.037,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                "last updated: No records",
                                softWrap: true,
                                style: textStyle(screenHeight * 0.017,
                                    FontWeight.w700, Colors.grey.shade500),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent),
                            onPressed: () async {
                              posts.isEmpty ? await getStoredPosts() : null;
                              if (!mounted) return;
                              Provider.of<TagBookProvider2>(context,
                                      listen: false)
                                  .changeImage1(listOfFilterIds[0]);
                              applyFilters();
                              Provider.of<IconProvider>(context, listen: false)
                                  .selectTag('');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChangeNotifierProvider(
                                      create: (BuildContext context) {
                                        Tapped(false);
                                      },
                                      child: const MyTagBook()),
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.all(screenHeight * 0.015),
                              child: Text(
                                "View",
                                style: textStyle(screenHeight * 0.022,
                                    FontWeight.bold, Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SpacedBoxBig(),
                      Text(
                        "Hi there! I'm for keeping all your important links and texts tagged in one place, ready whenever you need them.",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: screenHeight * 0.017,
                        ),
                      ),
                      const SpacedBoxLarge(),
                      Text(
                        "My tags",
                        style: textStyle(screenHeight * 0.022, FontWeight.bold,
                            Colors.black),
                      ),
                      SizedBox(
                        height: screenHeight * 0.017,
                      ),
                      Expanded(
                        child: GridView.builder(
                          itemCount: tags.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            bool selected = Provider.of<IconProvider>(context)
                                    .selectedIconId ==
                                tags[index].tagID;
                            selected
                                ? {
                                    listOfFilterIds.clear(),
                                    listOfFilterIds.add(tags[index].iconImage),
                                  }
                                : null;
                            if (index == tags.length) {
                              return GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () async {
                                  iconList.isEmpty
                                      ? await getStoredIcons()
                                      : null;
                                  if (!mounted) return;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditTags(
                                          addTag: true, iconLists: iconList),
                                    ),
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.grey.shade300),
                                      ),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.all(screenHeight * 0.02),
                                        child: SvgPicture.asset(
                                            'assets/images/add.svg',
                                            height: screenHeight * 0.037),
                                      ),
                                    ),
                                    SizedBox(
                                      height: screenHeight * 0.005,
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            right: screenWidth * 0.025),
                                        child: const Text('Add tag'),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            } else {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Provider.of<IconProvider>(context,
                                              listen: false)
                                          .selectTag(tags[index].tagID);
                                      selected
                                          ? setState(() {
                                              listOfFilterIds
                                                  .add(tags[index].iconImage);
                                            })
                                          : null;
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: selected
                                            ? Colors.blue
                                            : Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.grey.shade300),
                                      ),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.all(screenHeight * 0.02),
                                        child: SvgPicture.network(
                                          tags[index].iconImage,
                                          height: screenHeight * 0.037,
                                          color: selected ? Colors.white : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.005,
                                  ),
                                  Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          right: screenWidth * 0.025),
                                      child: Text(tags[index].tagName),
                                    ),
                                  )
                                ],
                              );
                            }
                          },
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 0.7,
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 2,
                                  crossAxisSpacing: 10),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            BottomPageButton(
                text: 'Add To Tag Book',
                func: () async {
                  posts.isEmpty ? await getStoredPosts() : null;
                  if (!mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                        create: (BuildContext context) => Tapped(false),
                        child: const MyTagBook(),
                      ),
                    ),
                  );
                },
                bgColor: Colors.black,
                textStyle: textStyle(
                    screenHeight * 0.022, FontWeight.bold, Colors.white))
          ]),
        ),
      ),
    );
  }
}
