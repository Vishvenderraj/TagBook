import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tag_book/postTags/Provider/provider_tagbook.dart';

import '../../common/styles/styles.dart';
import '../../common/widgets/custom_fields_and_button.dart';
import '../MainPage/my_tagbook.dart';
class PostTagSelection extends StatelessWidget {
  const PostTagSelection({super.key, required this.tagBookProvider});
final TagBookProvider tagBookProvider;
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Consumer<MultiTapped>(
              builder: (context, multiTappedProvider, child) => ListView(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.06,
                      left: MediaQuery.of(context).size.width * 0.09,
                      right: MediaQuery.of(context).size.width * 0.09,
                    ),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                      color: Colors.white,
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
                                  'Select Tags',
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.height * 0.037,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    height: 0,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.007),
                                  child: Text(
                                    'you can choose up-to: 3 tags',
                                    softWrap: true,
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.height * 0.017,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                tagBookProvider.setDefaultValues();
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
                        const SizedBox(height: 16), // Replace SpacedBoxBig with SizedBox
                        SelectTagsMenu(
                          screenHeight: MediaQuery.of(context).size.height,
                          pressed: multiTappedProvider.isTapped,
                          onPressed: () {
                            multiTappedProvider.tapped();
                          },
                          title: tagBookProvider.getTagTitle1,
                          image: tagBookProvider.getImageTitle1,
                          tagID: tagBookProvider.getTagID1,
                          callNumber: 1, filterTags: false,
                        ),
                        multiTappedProvider.isTapped
                            ? const SizedBox() : SelectTagsMenu(
                          screenHeight: MediaQuery.of(context).size.height,
                          pressed: multiTappedProvider.isTapped1,
                          onPressed: () {
                            multiTappedProvider.tapped1();
                          },
                          title: tagBookProvider.getTagTitle2,
                          image: tagBookProvider.getImageTitle2,
                          tagID: tagBookProvider.getTagID2,
                          callNumber: 2, filterTags: false,
                        ),
                        multiTappedProvider.isTapped || multiTappedProvider.isTapped1
                            ? const SizedBox()
                            : SelectTagsMenu(
                          screenHeight: MediaQuery.of(context).size.height,
                          pressed: multiTappedProvider.isTapped2,
                          onPressed: () {
                            multiTappedProvider.tapped2();
                          },
                          title: tagBookProvider.getTagTitle3,
                          image: tagBookProvider.getImageTitle3,
                          tagID: tagBookProvider.getTagID3,
                          callNumber: 3, filterTags: false,
                        ),
                        const SizedBox(height: 16), // Replace SpacedBox with SizedBox
                        ContButton(
                          func: () {
                            listsOfTags.clear();
                            if (tagBookProvider.getTagID1 != '' ||
                                tagBookProvider.getTagID2 != '' ||
                                tagBookProvider.getTagID3 != '') {
                              tagBookProvider.getTagID1.isNotEmpty ? listsOfTags.add(tagBookProvider.getTagID1) : null;
                              tagBookProvider.getTagID2.isNotEmpty ? listsOfTags.add(tagBookProvider.getTagID2) : null;
                              tagBookProvider.getTagID3.isNotEmpty ? listsOfTags.add(tagBookProvider.getTagID3) : null;
                              Navigator.pop(context);
                            }
                          },
                          txt: tagBookProvider.getTagID1 != '' ||
                              tagBookProvider.getTagID2 != '' ||
                              tagBookProvider.getTagID3 != ''?'Update Tags':'Add Tags', bgColor: Colors.black, txtColor: Colors.white, showLoader: false,
                        ),
                        const SizedBox(height: 16), // Replace SpacedBox with SizedBox
                        Text(
                          'add new tag',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height * 0.017,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(screenHeight*0.022),
            child: Text('keep all your important links and texts tagged in one place, ready whenever you need them. ',textAlign: TextAlign.center,style:
            textStyle(MediaQuery.sizeOf(context).height*0.017,FontWeight.w500, Colors.black),),
          )
        ],
      ),
    );
  }
}
