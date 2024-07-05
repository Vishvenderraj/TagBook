import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../common/styles/styles.dart';
import '../../../common/widgets/custom_fields_and_button.dart';
import '../wigdets/fetch_tagicons.dart';
import '../wigdets/fetch_tags.dart';
import '../wigdets/provider_icos.dart';

class EditTags extends StatefulWidget {
  const EditTags({super.key, required this.addTag});
  final bool addTag;

  @override
  State<EditTags> createState() => _EditTagsState();
}

class _EditTagsState extends State<EditTags> {
  String iconId = '';
  bool showLoader = false;
  TextEditingController tagName = TextEditingController();
  TextEditingController descr = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.addTag ? 'Create a Tag' : 'Edit Tags',
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
                          widget.addTag
                              ? 'you can manage tags: from my profile'
                              : 'manage your tags',
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
              Text(
                'Enter Tag Name',
                style: textStyle(
                    screenHeight * 0.022, FontWeight.w900, Colors.black),
              ),
              const SpacedBox(),
              CustomTextField(
                text: 'Workout',
                iconData: null,
                maxLen: 20,
                suffixIcon: false,
                preffixIcon: true,
                func: (value) {},
                controller: tagName,
                keyboardType: TextInputType.text,
                validField: true,
                onPressed: () {},
                visibility: false,
              ),
              const SpacedBoxBig(),
              Text(
                'Select Icon',
                style: textStyle(
                    screenHeight * 0.022, FontWeight.w900, Colors.black),
              ),
              FutureBuilder<List<FetchIcons>>(
                future: fetchAllIconData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No icons found'));
                  } else {
                    final icons = snapshot.data!;
                    return Consumer<IconProvider>(
                      builder: (context, iconProvider, child) {
                        return SizedBox(
                          height: screenHeight * 0.065,
                          width: screenWidth,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: icons.length,
                            itemBuilder: (context, index) {
                              final iconData = icons[index];
                              return IconSelection(
                                image: iconData.iconImage,
                                selectedIcon: iconProvider.selectedTagId == iconData.id,
                                iconID: iconData.id,
                                func: () {
                                  iconProvider.selectTag(iconData.id);
                                },
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
              Text(
                'Enter Description',
                style: textStyle(
                  screenHeight * 0.022,
                  FontWeight.w700,
                  Colors.black,
                ),
              ),
              const SpacedBox(),
              Container(
                height: screenHeight * 0.14,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade400)),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03,
                      vertical: screenHeight * 0.004),
                  child: TextFormField(
                    expands: true,
                    maxLines: null,
                    cursorColor: Colors.black,
                    cursorWidth: 1,
                    maxLength: 150,
                    controller: descr,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: 'Please share your feedback',
                      hintStyle: TextStyle(
                          color: Colors.grey.shade300,
                          fontWeight: FontWeight.w400),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 1.2),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 1.2),
                      ),
                    ),
                  ),
                ),
              ),
              const SpacedBoxBig(),
              ContButton(
                func: widget.addTag
                    ? () async {
                        {
                          setState(() {
                            showLoader = true;
                          });
                          try {
                            await createTag(tagName.text, iconId, descr.text);
                          } catch (e) {
                            setState(() {
                              showLoader = false;
                            });
                            debugPrint(e.toString());
                          }
                        }
                      }
                    : () {
                        editTag(tagName.text);
                      },
                txt: widget.addTag ? 'Create Tag' : 'Update',
                bgColor: widget.addTag ? Colors.black : Colors.grey.shade800,
                txtColor: widget.addTag ? Colors.white : Colors.grey.shade300,
                showLoader: showLoader,
              ),
              const SpacedBoxBig(),
              widget.addTag
                  ? const SizedBox()
                  : Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.red.shade300),
                          borderRadius: BorderRadius.circular(30)),
                      child: ContButton(
                        func: () {},
                        txt: 'Delete',
                        bgColor: Colors.white,
                        txtColor: Colors.red,
                        showLoader: false,
                      ),
                    ),
              const Spacer(),
              widget.addTag
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.027,
                          horizontal: screenWidth * 0.027),
                      child: Text(
                        "keep all your important links and texts tagged in one place, ready whenever you need them. ",
                        style: textStyle(screenHeight * 0.017, FontWeight.w500,
                            Colors.black),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class IconSelection extends StatelessWidget {
  const IconSelection({
    super.key,
    required this.image,
    required this.func,
    required this.selectedIcon,
    required this.iconID,
  });

  final String image;
  final bool selectedIcon;
  final Function()? func;
  final String iconID;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Padding(
      padding: EdgeInsets.only(right: screenWidth * 0.04),
      child: GestureDetector(
        onTap: func,
        child: Container(
          width: screenWidth * 0.13,
          height: screenHeight * 0.13,
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.008, vertical: screenHeight * 0.008),
          decoration: BoxDecoration(
            border: Border.all(
                color: selectedIcon ? Colors.blue : Colors.grey.shade300),
            shape: BoxShape.circle,
          ),
          child: Material(
            color: Colors.transparent,
            elevation: selectedIcon ? 2 : 0,
            shape: const CircleBorder(),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                shape: BoxShape.circle,
                color: selectedIcon ? Colors.blue : Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.011,
                    vertical: screenHeight * 0.011),
                child: SvgPicture.network(
                  image,
                  fit: BoxFit.contain,
                  color: selectedIcon ? CupertinoColors.white : null,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
