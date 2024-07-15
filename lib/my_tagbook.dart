import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:tag_book/Menu/MyTags/wigdets/fetch_tags.dart';
import 'package:tag_book/common/styles/styles.dart';
import 'package:tag_book/common/widgets/custom_fields_and_button.dart';
import 'package:tag_book/provider_tagbook.dart';

List<String> listsOfTags = [];

class MyTagBook extends StatefulWidget {
  const MyTagBook({super.key});

  @override
  State<MyTagBook> createState() => _MyTagBookState();
}

class _MyTagBookState extends State<MyTagBook> {
  late Future<List<FetchPosts>> futurePosts;
  TextEditingController postTextEditingController = TextEditingController();

  String ur1 = '';
  String message = '';
  int count = 0;

/*  void _getMetadata(String url) async {
    bool isValid = _getUrlValid(url);
    if (isValid) {
      Metadata? _metadata = await AnyLinkPreview.getMetadata(
        link: url,
        cache: const Duration(days: 7),
      );
    } else {
      debugPrint("URL is not valid");
    }
  }*/

  bool _getUrlValid(String url) {
    bool isUrlValid = AnyLinkPreview.isValidLink(
      url,
      protocols: ['http', 'https'],
      hostWhitelist: ['https://youtube.com/'],
      hostBlacklist: ['https://facebook.com/'],
    );
    return isUrlValid;
  }

  @override
  void dispose() {
    postTextEditingController.dispose();
    super.dispose();
  }

  void validateContent(String string) {
    final text = string.split(RegExp(r'[ \n]'));
    final link = text.isNotEmpty ? text.first : '';
    if (_getUrlValid(link)) {
      setState(() {
        ur1 = link;
        message = string.replaceAll(link, '').trim();
      });
    } else {
      setState(() {
        ur1 = '';
        message = string;
      });
    }
  }

  @override
  void initState() {
    futurePosts = getAllPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.sizeOf(context).height;
    var screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: screenHeight * 0.09,
        elevation: 3,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.grey.shade200,
        flexibleSpace: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(
                  left: screenWidth * 0.05,
                  top: screenHeight * 0.04,
                  bottom: screenHeight * 0.01),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'My Tag Book',
                    style: textStyle(
                        screenHeight * 0.035, FontWeight.w800, Colors.black),
                  ),
                  SizedBox(
                    width: screenWidth * 0.2,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: SvgPicture.asset('assets/images/searchButton.svg'),
                  ),
                  SizedBox(
                    width: screenWidth * 0.0225,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: SvgPicture.asset('assets/images/tags.svg'),
                  ),
                  SizedBox(
                    width: screenWidth * 0.0225,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Material(
                      elevation: 5,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.black,
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<FetchPosts>>(
                future: futurePosts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No posts found'));
                  } else {
                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) =>
                          ChangeNotifierProvider(
                            create: (BuildContext context) {
                              return TagBookProvider();
                            },
                            child: Posts(
                              controller: postTextEditingController,
                              url: posts[index].content
                                  .split(RegExp(r'[ \n]'))
                                  .first,
                              message: posts[index].content.replaceAll(
                                  posts[index].content
                                      .split(RegExp(r'[ \n]'))
                                      .first, '').trim(),
                            ),
                          ),
                    );
                  }
                }),
            ),
            Container(
              height:
                  ur1.isNotEmpty ? screenHeight * 0.22 : screenHeight * 0.07,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (ur1.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.01),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border:
                                    Border.all(color: Colors.grey.shade300)),
                            child: AnyLinkPreview(
                              displayDirection:
                                  UIDirection.uiDirectionHorizontal,
                              backgroundColor: Colors.white,
                              borderRadius: 20,
                              removeElevation: true,
                              previewHeight: screenHeight * 0.1,
                              link: ur1,
                              cache: const Duration(hours: 1),
                            ),
                          ),
                        ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                enableDrag: false,
                                isScrollControlled: true,
                                isDismissible: true,
                                context: context,
                                builder: (BuildContext context) =>
                                    MultiProvider(
                                  providers: [
                                    ChangeNotifierProvider(
                                      create: (BuildContext context) =>
                                          MultiTapped(),
                                    ),
                                    ChangeNotifierProvider(
                                      create: (BuildContext context) =>
                                          TagBookProvider(),
                                    ),
                                  ],
                                  child: DraggableScrollableSheet(
                                    initialChildSize: 0.5,
                                    minChildSize: 0.5,
                                    maxChildSize: 1.0,
                                    expand: false,
                                    builder: (BuildContext context,
                                            ScrollController
                                                scrollController) =>
                                        ListView(
                                            controller: scrollController,
                                            children: [
                                          Container(
                                            height: screenHeight,
                                            width: screenWidth,
                                            padding: EdgeInsets.only(
                                              top: screenHeight * 0.06,
                                              left: screenWidth * 0.09,
                                              right: screenWidth * 0.09,
                                            ),
                                            decoration: const BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(20),
                                              ),
                                              color: Colors.white,
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Select Tags',
                                                          style: TextStyle(
                                                            fontSize:
                                                                screenHeight *
                                                                    0.037,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                            height: 0,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      screenHeight *
                                                                          0.007),
                                                          child: Text(
                                                            'you can choose up-to: 3 tags',
                                                            softWrap: true,
                                                            style: textStyle(
                                                              screenHeight *
                                                                  0.017,
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
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(60),
                                                        child:
                                                            const CircleAvatar(
                                                          radius: 25,
                                                          backgroundColor:
                                                              Colors.black,
                                                          child: Icon(
                                                            CupertinoIcons
                                                                .xmark,
                                                            color:
                                                                CupertinoColors
                                                                    .white,
                                                            size: 25,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SpacedBoxBig(),
                                                SelectTagsMenu(
                                                  screenHeight: screenHeight,
                                                  pressed:
                                                      Provider.of<MultiTapped>(
                                                              context)
                                                          .isTapped,
                                                  onPressed: () {
                                                    Provider.of<MultiTapped>(
                                                            context,
                                                            listen: false)
                                                        .tapped();
                                                  },
                                                  title: Provider.of<
                                                              TagBookProvider>(
                                                          context)
                                                      .getTagTitle1,
                                                  image: Provider.of<
                                                              TagBookProvider>(
                                                          context)
                                                      .getImageTitle1,
                                                  tagID: Provider.of<
                                                              TagBookProvider>(
                                                          context)
                                                      .getTagID1,
                                                  callNumber: 1,
                                                ),
                                                Provider.of<MultiTapped>(
                                                            context)
                                                        .isTapped
                                                    ? const SizedBox()
                                                    : SelectTagsMenu(
                                                        screenHeight:
                                                            screenHeight,
                                                        pressed: Provider.of<
                                                                    MultiTapped>(
                                                                context)
                                                            .isTapped1,
                                                        onPressed: () {
                                                          Provider.of<MultiTapped>(
                                                                  context,
                                                                  listen: false)
                                                              .tapped1();
                                                        },
                                                        title: Provider.of<
                                                                    TagBookProvider>(
                                                                context)
                                                            .getTagTitle2,
                                                        image: Provider.of<
                                                                    TagBookProvider>(
                                                                context)
                                                            .getImageTitle2,
                                                        tagID: Provider.of<
                                                                    TagBookProvider>(
                                                                context)
                                                            .getTagID2,
                                                        callNumber: 2,
                                                      ),
                                                Provider.of<MultiTapped>(
                                                                context)
                                                            .isTapped ||
                                                        Provider.of<MultiTapped>(
                                                                context)
                                                            .isTapped1
                                                    ? const SizedBox()
                                                    : SelectTagsMenu(
                                                        screenHeight:
                                                            screenHeight,
                                                        pressed: Provider.of<
                                                                    MultiTapped>(
                                                                context)
                                                            .isTapped2,
                                                        onPressed: () {
                                                          Provider.of<MultiTapped>(
                                                                  context,
                                                                  listen: false)
                                                              .tapped2();
                                                        },
                                                        title: Provider.of<
                                                                    TagBookProvider>(
                                                                context)
                                                            .getTagTitle3,
                                                        image: Provider.of<
                                                                    TagBookProvider>(
                                                                context)
                                                            .getImageTitle3,
                                                        tagID: Provider.of<
                                                                    TagBookProvider>(
                                                                context)
                                                            .getTagID3,
                                                        callNumber: 3,
                                                      ),
                                                const SpacedBox(),
                                                ContButton(
                                                    func: () {
                                                      if (Provider.of<TagBookProvider>(context, listen: false).getTagID1 != '' ||
                                                          Provider.of<TagBookProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .getTagID2 !=
                                                              '' ||
                                                          Provider.of<TagBookProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .getTagID3 !=
                                                              '') {
                                                        Provider.of<TagBookProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .getTagID1
                                                                .isNotEmpty
                                                            ? listsOfTags.add(
                                                                Provider.of<TagBookProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .getTagID1)
                                                            : null;
                                                        Provider.of<TagBookProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .getTagID2
                                                                .isNotEmpty
                                                            ? listsOfTags.add(
                                                                Provider.of<TagBookProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .getTagID2)
                                                            : null;
                                                        Provider.of<TagBookProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .getTagID3
                                                                .isNotEmpty
                                                            ? listsOfTags.add(
                                                                Provider.of<TagBookProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .getTagID3)
                                                            : null;
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                    txt: 'Add Tags',
                                                    bgColor: Colors.black,
                                                    txtColor: Colors.white,
                                                    showLoader: false),
                                                const SpacedBox(),
                                                Text(
                                                  'add new tag',
                                                  style: textStyle(
                                                      screenHeight * 0.017,
                                                      FontWeight.w400,
                                                      Colors.grey.shade400),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ]),
                                  ),
                                ),
                              );
                            },
                            child: SvgPicture.asset('assets/images/tags.svg'),
                          ),
                          SizedBox(
                            width: screenWidth * 0.07,
                          ),
                          Expanded(
                            child: TextField(
                              maxLines: null,
                              autofocus: false,
                              autocorrect: false,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              controller: postTextEditingController,
                              onChanged: (string) {
                                validateContent(string);
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter your message',
                                hintStyle: textStyle(screenHeight * 0.022,
                                    FontWeight.w400, Colors.grey.shade400),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.transparent, width: 1.2),
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.transparent, width: 1.2),
                                ),
                                errorBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.transparent, width: 1.2),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                             setState(() {
                               posts.add(FetchPosts(content: postTextEditingController.text, iconImage: ''));
                             });
                              if (postTextEditingController.text.isNotEmpty) {
                                if (await createPost(postTextEditingController.text, listsOfTags)) {
                                  postTextEditingController.setText('');
                                  listsOfTags.clear();
                                }
                              }
                              setState(() {
                                ur1 = '';
                              });
                            },
                            child: SvgPicture.asset(
                              'assets/images/disabledEnterButton.svg',
                              color: postTextEditingController.text.isNotEmpty
                                  ? Colors.blue
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectTagsMenu extends StatefulWidget {
  const SelectTagsMenu(
      {super.key,
      required this.screenHeight,
      required this.pressed,
      required this.onPressed,
      required this.title,
      required this.image,
      required this.tagID,
      required this.callNumber});

  final double screenHeight;
  final bool pressed;
  final Function() onPressed;
  final String title;
  final String image;
  final String tagID;
  final int callNumber;
  @override
  State<SelectTagsMenu> createState() => _SelectTagsMenuState();
}

class _SelectTagsMenuState extends State<SelectTagsMenu> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:
          widget.pressed ? widget.screenHeight / 2 : widget.screenHeight / 13,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Material(
          elevation: widget.pressed ? 5 : 0,
          shadowColor: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(30),
            topRight: const Radius.circular(30),
            bottomLeft: Radius.circular(widget.pressed ? 20 : 30),
            bottomRight: Radius.circular(widget.pressed ? 20 : 30),
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: widget.pressed ? Colors.blue : Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: widget.screenHeight * 0.026,
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child:
                            widget.image.startsWith('assets/images/Vector.svg')
                                ? SvgPicture.asset(widget.image)
                                : SvgPicture.network(widget.image),
                      ),
                    ),
                  ),
                  title: Text(
                    widget.title,
                    style: textStyle(
                      widget.screenHeight * 0.018,
                      FontWeight.bold,
                      Colors.black,
                    ),
                  ),
                  trailing: Icon(
                    widget.pressed
                        ? CupertinoIcons.chevron_up
                        : CupertinoIcons.chevron_down,
                    color: Colors.grey.shade500,
                    size: 20,
                  ),
                ),
              ),
              if (widget.pressed)
                Flexible(
                  child: ListView.builder(
                    itemCount: tags.length,
                    itemBuilder: (context, idx) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Call the onSelection callback
                            if (widget.callNumber == 1) {
                              Provider.of<TagBookProvider>(context,
                                      listen: false)
                                  .setTagID1(tags[idx].tagID);
                              Provider.of<TagBookProvider>(context,
                                      listen: false)
                                  .changeImage1(tags[idx].iconImage);
                              Provider.of<TagBookProvider>(context,
                                      listen: false)
                                  .changeTitle1(tags[idx].tagName);
                            } else if (widget.callNumber == 2) {
                              Provider.of<TagBookProvider>(context,
                                      listen: false)
                                  .setTagID2(tags[idx].tagID);
                              Provider.of<TagBookProvider>(context,
                                      listen: false)
                                  .changeImage2(tags[idx].iconImage);
                              Provider.of<TagBookProvider>(context,
                                      listen: false)
                                  .changeTitle2(tags[idx].tagName);
                            } else {
                              Provider.of<TagBookProvider>(context,
                                      listen: false)
                                  .setTagID3(tags[idx].tagID);
                              Provider.of<TagBookProvider>(context,
                                      listen: false)
                                  .changeImage3(tags[idx].iconImage);
                              Provider.of<TagBookProvider>(context,
                                      listen: false)
                                  .changeTitle3(tags[idx].tagName);
                            }
                            setState(() {
                              selected = true;
                              if (selected) {
                                if (widget.pressed) {
                                  if (widget.callNumber == 1)
                                    Provider.of<MultiTapped>(context,
                                            listen: false)
                                        .tapped();
                                  if (widget.callNumber == 2)
                                    Provider.of<MultiTapped>(context,
                                            listen: false)
                                        .tapped1();
                                  if (widget.callNumber == 3)
                                    Provider.of<MultiTapped>(context,
                                            listen: false)
                                        .tapped2();
                                }
                              }
                            });
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: SvgPicture.network(tags[idx].iconImage),
                            ),
                            title: Text(
                              tags[idx].tagName,
                              style: textStyle(
                                widget.screenHeight * 0.018,
                                FontWeight.bold,
                                Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                          thickness: 0.5,
                        ),
                        const SpacedBox(),
                      ],
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

class Posts extends StatelessWidget {
  const Posts({
    super.key,
    required this.controller,
    required this.url,
    required this.message,
  });
  final TextEditingController controller;
  final String url;
  final String message;
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.sizeOf(context).height;
    var screenWidth = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.008, horizontal: screenWidth * 0.06),
      child: Container(
        margin: EdgeInsets.only(top: screenHeight * 0.015),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: AnyLinkPreview(
                  removeElevation: true,
                  backgroundColor: Colors.white,
                  previewHeight: screenHeight * 0.12,
                  borderRadius: 10,
                  displayDirection: UIDirection.uiDirectionHorizontal,
                  link: url,
                  cache: const Duration(hours: 1),
                ),
              ),
              const SpacedBox(),
              Text(
                url,
                style: textStyle(
                    screenHeight * 0.017, FontWeight.bold, Colors.blue),
              ),
              const SpacedBox(),
              Text(
                message,
                style: textStyle(
                    screenHeight * 0.017, FontWeight.w500, Colors.black),
              ),
              const SpacedBox(),
              Divider(
                color: Colors.grey.shade300,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(Provider.of<TagBookProvider>(context, listen: false)
                      .getTagID1),
                  Text(
                    '20-10-24 | 10:26 pm',
                    style: textStyle(screenHeight * 0.017, FontWeight.w400,
                        Colors.grey.shade500),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
