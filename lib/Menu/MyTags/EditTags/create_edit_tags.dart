import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tag_book/Menu/MyTags/my_tags.dart';
import 'package:tag_book/common/widgets/loader_provider.dart';
import '../../../common/styles/styles.dart';
import '../../../common/widgets/custom_fields_and_button.dart';
import '../wigdets/fetch_tagicons.dart';
import '../wigdets/fetch_tags.dart';
import '../wigdets/provider_icos.dart';

class EditTags extends StatefulWidget {
  const EditTags({super.key, required this.addTag, this.tagID, required this.iconLists, this.iconID, this.tagDescr, this.tagName});
  final bool addTag;
  final String? tagID;
  final String? iconID;
  final String? tagDescr;
  final String? tagName;

  final List<FetchIcons> iconLists;
  @override
  State<EditTags> createState() => _EditTagsState();
}

class _EditTagsState extends State<EditTags> {
  TextEditingController tagName = TextEditingController();
  TextEditingController descr = TextEditingController();
  @override
  void initState() {
    widget.addTag?Provider.of<IconProvider>(context,listen: false).reset():(tagName.text = widget.tagName!,descr.text = widget.tagDescr!);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;

    return PopScope(
      canPop: false,
      onPopInvoked: (isPop)
     async {
        if(isPop) return;
        await getAllTag();
       if(!mounted) return;
        widget.addTag? Navigator.pop(context) :{
          Navigator.pop(context),
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const MyTags(),),),
        };
      },
      child: Scaffold(
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
                        Title(
                          color: Colors.black,
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/images/tags.svg'),
                              SizedBox(width: screenWidth*0.02,),
                              Text(
                                widget.addTag ? 'Create a Tag' : 'Edit Tags',
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: screenHeight * 0.035,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.005,
                          ),
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
                      onTap: () async{
                        await getAllTag();
                        if(!mounted) return;
                        widget.addTag?
                        {
                          Navigator.pop(context)
                        } :{
                          Navigator.pop(context),
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const MyTags(),),)
                        };
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Enter Tag Name',
                      style: textStyle(
                          screenHeight * 0.022, FontWeight.w900, Colors.black),
                    ),
                    widget.addTag?Provider.of<TagEditProvider>(context).validTagName?const SizedBox():Text(
                      "Tag Name can't be empty",style: textStyle(screenHeight * 0.017, FontWeight.w400, Colors.red),
                    ):const SizedBox(),
                  ],
                ),
                const SpacedBox(),
                CustomTextField(
                  text:'TagName',
                  iconData: null,
                  maxLen: 20,
                  suffixIcon: false,
                  preffixIcon: true,
                  func: (value) {},
                  controller: tagName,
                  keyboardType: TextInputType.text,
                  validField: Provider.of<TagEditProvider>(context).validTagName,
                  onPressed: () {
                  },
                  visibility: false,
                ),
                const SpacedBoxBig(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Icon',
                      style: textStyle(
                          screenHeight * 0.022, FontWeight.w900, Colors.black),
                    ), Provider.of<IconProvider>(context).isSelected?const SizedBox():Text(
                      'Please select an icon',
                      style: textStyle(
                          screenHeight * 0.017, FontWeight.w400, Colors.red),
                    )
                  ],
                ),
                const SpacedBox(),
                Consumer<IconProvider>(
                        builder: (context, iconProvider, child) {
                          return SizedBox(
                            height: screenHeight * 0.065,
                            width: screenWidth,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.iconLists.length,
                              itemBuilder: (context, index) {
                                final iconData = widget.iconLists[index];
                                final selected = widget.addTag?iconProvider.selectedIconId == iconData.id : iconProvider.selectedIconId == null? iconData.id == widget.iconID : iconProvider.selectedIconId == iconData.id;
                                return IconSelection(
                                  image: iconData.iconImage,
                                  selectedIcon: selected,
                                  iconID: iconData.id,
                                  func: () {
                                    iconProvider.selectTag(iconData.id);
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),

                const SpacedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Enter Description',
                      style: textStyle(
                        screenHeight * 0.022,
                        FontWeight.w700,
                        Colors.black,
                      ),
                    ),widget.addTag?Provider.of<TagEditProvider>(context).validDescr?const SizedBox():Text(
                      'please enter description',
                      style: textStyle(
                        screenHeight * 0.017,
                        FontWeight.w400,
                        Colors.red,
                      ),
                    ):const SizedBox(),
                  ],
                ),
                const SpacedBox(),
                Container(
                  height: screenHeight * 0.14,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      border: Border.all(color: Provider.of<TagEditProvider>(context).validDescr?Colors.grey.shade400:Colors.red),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03,
                        vertical: screenHeight * 0.004),
                    child: TextFormField(
                      expands: true,
                      maxLines: null,
                      onTapOutside: (PointerDownEvent event){
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
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
                               Provider.of<IconProvider>(context,listen: false).checkIfSelected(Provider.of<IconProvider>(context,listen: false).selectedIconId);
                               Provider.of<TagEditProvider>(context,listen: false).checkIfValidInput(tagName.text.isEmpty, descr.text.isEmpty);

                            if(tagName.text.isNotEmpty && Provider.of<IconProvider>(context,listen: false).selectedIconId!=null && descr.text.isNotEmpty)
                            {
                              Provider.of<ShowLoader>(context,listen: false).startLoader();
                              if(await createTag(tagName.text, Provider.of<IconProvider>(context,listen: false).selectedIconId!, descr.text) && (mounted))
                                {
                                  Provider.of<ShowLoader>(context,listen: false).stopLoader();
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) => Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: screenWidth * 0.07,
                                            vertical: screenHeight * 0.04,
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: screenWidth * 0.07,
                                                ),
                                                SvgPicture.asset(
                                                    'assets/images/passkey.svg'),
                                              ],
                                            ),
                                            const SpacedBoxBig(),
                                            Text(
                                              'New Tag is available',
                                              style: textStyle(screenHeight * 0.016,
                                                  FontWeight.w400, Colors.black),
                                            ),
                                            const SpacedBox(),
                                            Text(
                                              'New Tag has been created',
                                              style: textStyle(screenHeight * 0.016,
                                                  FontWeight.w400, Colors.black),
                                            ),
                                            const SpacedBoxBig(),
                                            ContButton(
                                                showLoader: false,
                                                func: () {
                                                  Navigator.pop(context);
                                                },
                                                txt: 'Okay',
                                                bgColor: Colors.black,
                                                txtColor: CupertinoColors.white)
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                            }
                            else{
                              Provider.of<ShowLoader>(context,listen: false).stopLoader();
                            }
                          }
                        :() async{
                            Provider.of<ShowLoader>(context,listen: false).startLoader();
                           if(await editTag(tagName: tagName.text, tagID: widget.tagID!, iconID: Provider.of<IconProvider>(context,listen: false).selectedIconId ?? widget.iconID!, description: descr.text) && (mounted))
                             {
                               Provider.of<ShowLoader>(context,listen: false).stopLoader();
                             }
                           else{
                             print("failed");
                           }
                          },
                    txt: widget.addTag ? 'Create Tag' : 'Update',
                    bgColor: widget.addTag ? Colors.black : Colors.grey.shade800,
                    txtColor: widget.addTag ? Colors.white : Colors.grey.shade300,
                    showLoader: Provider.of<ShowLoader>(context).showLoader,
                ),
                const SpacedBoxBig(),
                widget.addTag
                    ? const SizedBox()
                    : Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.red.shade300),
                            borderRadius: BorderRadius.circular(30)),
                        child: ContButton(
                          func: () async{
                            print(tags.length);
                            Provider.of<ShowLoader>(context,listen: false).startLoader2();
                           if(await deleteTag("669f94733119ec7d7e6f72bd")) {
                             tags.removeWhere((tag) => tag.tagID == widget.tagID);
                             if(!mounted)return;
                             Provider.of<ShowLoader>(context,listen: false).stopLoader2();
                             Navigator.pop(context);
                             Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const MyTags()));
                           }
                            if(!mounted)return;
                            Provider.of<ShowLoader>(context,listen: false).stopLoader2();
                          },
                          txt: 'Delete',
                          bgColor: Colors.white,
                          txtColor: Colors.red,
                          showLoader: Provider.of<ShowLoader>(context).showLoader2,
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
                          textAlign: TextAlign.center,
                          style: textStyle(screenHeight * 0.017, FontWeight.w500,
                              Colors.black),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
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
                    vertical: screenHeight * 0.011,
                ),
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
