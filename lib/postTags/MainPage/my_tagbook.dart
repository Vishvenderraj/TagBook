import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:tag_book/Menu/MyTags/wigdets/fetch_tags.dart';
import 'package:tag_book/common/styles/styles.dart';
import 'package:tag_book/postTags/PostTagSelection/post_tag_selection.dart';
import 'package:tag_book/postTags/Provider/provider_tagbook.dart';

import '../FilterTags/filter_tag.dart';

List<String> listsOfTags = [];

class MyTagBook extends StatefulWidget {
  const MyTagBook({super.key});

  @override
  State<MyTagBook> createState() => _MyTagBookState();
}

class _MyTagBookState extends State<MyTagBook> {
  final TextEditingController _postTextEditingController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _searchTerm = '';
  List<int> highlightedIndexes = [];
  int _currentIndex = -1;  // Keeps track of the index of the currently highlighted word


  String ur1 = '';
  String message = '';
  int count = 0;

  bool _getUrlValid(String url) {
      bool isUrlValid = AnyLinkPreview.isValidLink(
       url,
        protocols: ['http', 'https'],
        hostWhitelist: ['https://youtube.com/'],
        hostBlacklist: ['https://facebook.com/'],
      );
      return isUrlValid;
    }
  void validateContent(String string) {
    final text = string.split(RegExp(r'[ \n]'));
    final link = text.isNotEmpty ? text.first : '';

    if(_getUrlValid(link)) {

      setState(() {
        ur1 = link;
        message = string.replaceAll(link, '').trim();

      });
    } else {
      setState(() {
        message = string;
      });
    }
  }
  void _highlightSearchResults(String searchTerm) {
    highlightedIndexes.clear();
    for (int i = 0; i < posts.length; i++) {
      if (posts[i].content.toLowerCase().contains(searchTerm.toLowerCase()))
      {
        highlightedIndexes.add(i);
      }
    }
    if (highlightedIndexes.isNotEmpty) {
      setState(() {
        _currentIndex = 0;
      });
      _scrollToHighlighted(_currentIndex);
    } else {
      setState(() {
        _currentIndex = -1;
      });
    }
  }

  void _scrollToHighlighted(int index) {
    double itemHeight = MediaQuery.sizeOf(context).height*0.25; // Adjust based on your item height
    double offset = highlightedIndexes[index] * itemHeight;
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _previousHighlight() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      _scrollToHighlighted(_currentIndex);
    }
  }

  void _nextHighlight() {
    if (_currentIndex < highlightedIndexes.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _scrollToHighlighted(_currentIndex);
    }
  }

  Widget _buildHighlightedText(String text, String searchTerm) {
    if (searchTerm.isEmpty) {
      return Text(
        text,
        style: TextStyle(fontSize: MediaQuery.sizeOf(context).height*0.015, fontWeight: FontWeight.w500, color: Colors.black,
        ),
      );
    }

    List<TextSpan> spans = [];
    int start = 0;
    int index;
    while ((index = text.toLowerCase().indexOf(searchTerm.toLowerCase(), start)) != -1) {
      if (index > start) {
        spans.add(TextSpan(
          text: text.substring(start, index),
          style:  TextStyle(fontSize: MediaQuery.sizeOf(context).height*0.015, fontWeight: FontWeight.w500, color: Colors.black),
        ));
      }
      spans.add(TextSpan(
        text: text.substring(index, index + searchTerm.length),
        style:  TextStyle(fontSize: MediaQuery.sizeOf(context).height*0.015, fontWeight: FontWeight.w500, backgroundColor: Colors.black),
      ));
      start = index + searchTerm.length;
    }
    spans.add(TextSpan(
      text: text.substring(start),
      style: TextStyle(fontSize: MediaQuery.sizeOf(context).height*0.015, fontWeight: FontWeight.w500, color: Colors.black),
    ));

    return RichText(text: TextSpan(children: spans));
  }

  void removeFilters() async{
    filterOn = false;
  }

  @override
  void dispose() {
    _postTextEditingController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.sizeOf(context).height;
    var screenWidth = MediaQuery.sizeOf(context).width;
    return PopScope(
      canPop: false,
      onPopInvoked: (onPop){
        if(onPop) return;
        removeFilters();
        listOfFilterIds.clear();
        Provider.of<TagBookProvider>(context,listen: false).setDefaultValues();
        Provider.of<TagBookProvider2>(context,listen: false).setDefaultValues();
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: Provider.of<Tapped>(context).isTapped?screenHeight * 0.2:screenHeight * 0.1,
          elevation: 3,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.grey.shade200,
          flexibleSpace: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Padding(
              padding: EdgeInsets.only(
              left: screenWidth * 0.05,
                  top: screenHeight * 0.04,
                  bottom: screenHeight * 0.01,
              ),
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
                          onTap: () {
                            Provider.of<Tapped>(context,listen: false).tapped();
                          },
                          child: SvgPicture.asset('assets/images/searchButton.svg'),
                        ),
                        SizedBox(
                          width: screenWidth * 0.0225,
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                enableDrag: false,
                                isScrollControlled: false,
                                isDismissible: true,
                                backgroundColor: Colors.white,
                                context: context,
                                builder: (context)=>
                            GestureDetector(
                              onTap: (){
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>const FilterTag(),),);
                                },
                              child: Container(
                                height: screenHeight/2,
                                width: screenWidth,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child:Padding(
                                  padding: EdgeInsets.all(screenHeight*0.01),
                                  child: const FilterTag(),
                                ),
                              ),
                            )
                            );
                          },
                          child: SvgPicture.asset('assets/images/tags.svg'),
                        ),
                        SizedBox(
                          width: screenWidth * 0.0225,
                        ),
                        GestureDetector(
                          onTap: () {
                            removeFilters();
                            listOfFilterIds.clear();
                            Provider.of<TagBookProvider2>(context,listen: false).setDefaultValues();
                            Provider.of<TagBookProvider>(context,listen: false).setDefaultValues();
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
                  Provider.of<Tapped>(context).isTapped?Divider(
                    color: Colors.grey.shade300,
                  ): const SizedBox(),
                  Provider.of<Tapped>(context).isTapped?Padding(
                    padding:EdgeInsets.only(
                      top: screenHeight * 0.0125,
                        left: screenWidth * 0.02,

                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex:2,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.grey.shade300)
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.08),
                              child: TextField(
                                  maxLines: null,
                                  autofocus: false,
                                  autocorrect: false,
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.newline,
                                  controller: _searchController,
                                  onChanged: (value){
                                    _searchTerm = _searchController.text;
                                    _highlightSearchResults(_searchController.text);
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Search within all notes',
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
                                  )
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth*0.01,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal:screenWidth*0.03),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: _previousHighlight,
                                  icon: const Icon(CupertinoIcons.chevron_up,color: Colors.grey,),
                              ),
                              IconButton(
                                  onPressed: _nextHighlight,icon: const Icon(CupertinoIcons.chevron_down,color: Colors.grey,)),
                              Container(color: Colors.black,width: 2,height: 25,),
                              IconButton(
                                  onPressed: (){
                                    Provider.of<Tapped>(context,listen: false).tapped();
                                    _searchController.clear();
                                  },
                                  icon: const Icon(Icons.close,color: Colors.black,),)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ): const SizedBox()
                ],
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child:ListView.builder(
                  controller: _scrollController,
                  itemCount: filterOn?filteredPosts.length:posts.length,
                  itemBuilder: (context, index) {
                    bool checkForValidUrl = _getUrlValid(posts[index].content.split(RegExp(r'[ \n]')).first);
                       return Posts(
                         controller: _postTextEditingController,
                         url: checkForValidUrl? (
                             filterOn?
                             filteredPosts[index].content.split(RegExp(r'[ \n]')).first:
                             posts[index].content.split(RegExp(r'[ \n]')).first
                         ):'',
                         message: checkForValidUrl?(
                             filterOn?
                             _buildHighlightedText(filteredPosts[index].content.replaceAll(posts[index].content.split(RegExp(r'[ \n]')).first, '').trim(), _searchTerm) :
                             _buildHighlightedText(posts[index].content.replaceAll(posts[index].content.split(RegExp(r'[ \n]')).first, '').trim(), _searchTerm)
                         ):_buildHighlightedText(posts[index].content, _searchTerm),
                         image1:   filterOn?filteredPosts[index].image1:posts[index].image1,
                         image2:   filterOn?filteredPosts[index].image2:posts[index].image2,
                         image3:  filterOn?filteredPosts[index].image3:posts[index].image3,
                         dateCreated:  filterOn?filteredPosts[index].dateCreated:posts[index].dateCreated,
                       );
                  },
                ),
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
                  padding: const EdgeInsets.all(4.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ur1.isNotEmpty?
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
                          ):const SizedBox(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.white,surfaceTintColor: Colors.white,splashFactory: NoSplash.splashFactory, foregroundColor: CupertinoColors.white,elevation: 0),
                          onPressed: () {
                            final tagBookProvider = Provider.of<TagBookProvider>(context, listen: false);
                            showModalBottomSheet(
                              enableDrag: false,
                              isScrollControlled: false,
                              isDismissible: true,
                              backgroundColor: Colors.white,
                              context: context,
                              builder: (BuildContext context) => GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> PostTagSelection(tagBookProvider: tagBookProvider),),);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white
                                  ),
                                  height: screenHeight/2,
                                    child: Padding(
                                      padding: EdgeInsets.all(screenHeight*0.01),
                                      child: PostTagSelection(tagBookProvider: tagBookProvider),
                                    )),
                              )
                              /* Column(
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
                                ),*/
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
                                controller: _postTextEditingController,
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
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.white,surfaceTintColor: Colors.white,splashFactory: NoSplash.splashFactory,
                              foregroundColor: CupertinoColors.white,elevation: 0),
                              onPressed: () async {
                                if (_postTextEditingController.text.isNotEmpty) {
                                  if (await createPost(_postTextEditingController.text, listsOfTags)) {
                                    if(!mounted)return;
                                    setState(() {
                                      posts.add(
                                        FetchPosts(
                                          content: _postTextEditingController.text,
                                          image1: Provider.of<TagBookProvider>(context,listen: false).getImageTitle1,
                                          image2: Provider.of<TagBookProvider>(context,listen: false).getImageTitle2,
                                          image3: Provider.of<TagBookProvider>(context,listen: false).getImageTitle3,
                                          dateCreated:  DateFormat('yyyy-MM-dd').format(DateTime.now()),
                                        ),
                                      );
                                    },
                                    );
                                    _postTextEditingController.setText('');
                                    listsOfTags.clear();
                                  }
                                  await getAllPosts();
                                }
                                setState(() {
                                  ur1 = '';
                                });
                              },
                              child: SvgPicture.asset(
                                'assets/images/disabledEnterButton.svg',
                                color: _postTextEditingController.text.isNotEmpty
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
        required this.callNumber, required this.filterTags});

  final double screenHeight;
  final bool pressed;
  final Function() onPressed;
  final String title;
  final String image;
  final String tagID;
  final int callNumber;
  final bool filterTags;
  @override
  State<SelectTagsMenu> createState() => _SelectTagsMenuState();
}

class _SelectTagsMenuState extends State<SelectTagsMenu> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: widget.screenHeight / 13,
        maxHeight: widget.pressed ? widget.screenHeight / 2 : widget.screenHeight / 13,
      ),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: widget.pressed ? Colors.blue : Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ListTile(
                  leading: Container(
                    width: widget.screenHeight * 0.05,
                   decoration: BoxDecoration(color: Colors.white,shape: BoxShape.circle,border: Border.all(color: Colors.grey.shade300),),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: widget.image.isEmpty?SvgPicture.asset('assets/images/Vector.svg'):SvgPicture.network(widget.image),
                      ),
                    ),
                  ),
                  title: Text(
                    widget.title,
                    style: textStyle(
                      widget.screenHeight * 0.018,
                      FontWeight.bold,
                      Colors.grey.shade500,
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
                  child: ListView.separated(
                    itemCount: tags.length,
                    shrinkWrap: true,
                    itemBuilder: (context, idx) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Call the onSelection callback
                            setState(() {
                              selected = true;
                            });
                            if (selected) {
                              if (widget.pressed) {
                                 widget.filterTags?{
                                 if (widget.callNumber == 1) {
                                   Provider.of<TagBookProvider2>(context, listen: false).setTagID1(tags[idx].tagID),
                                   Provider.of<TagBookProvider2>(context, listen: false).changeImage1(tags[idx].iconImage),
                                   Provider.of<TagBookProvider2>(context, listen: false).changeTitle1(tags[idx].tagName),
                                   Provider.of<MultiTapped>(context, listen: false).tapped(),
                                 },
                                 if (widget.callNumber == 2) {
                                   Provider.of<MultiTapped>(context, listen: false).tapped1(),
                                   Provider.of<TagBookProvider2>(context, listen: false).setTagID2(tags[idx].tagID),
                                   Provider.of<TagBookProvider2>(context, listen: false).changeImage2(tags[idx].iconImage),
                                   Provider.of<TagBookProvider2>(context, listen: false).changeTitle2(tags[idx].tagName),
                                 },
                                 if (widget.callNumber == 3) {
                                   Provider.of<MultiTapped>(context, listen: false).tapped2(),
                                   Provider.of<TagBookProvider2>(context, listen: false).setTagID3(tags[idx].tagID),
                                   Provider.of<TagBookProvider2>(context, listen: false).changeImage3(tags[idx].iconImage),
                                   Provider.of<TagBookProvider2>(context, listen: false).changeTitle3(tags[idx].tagName),
                                 }
                                 }:{
                                   if (widget.callNumber == 1) {
                                     Provider.of<TagBookProvider>(context, listen: false).setTagID1(tags[idx].tagID),
                                     Provider.of<TagBookProvider>(context, listen: false).changeImage1(tags[idx].iconImage),
                                     Provider.of<TagBookProvider>(context, listen: false).changeTitle1(tags[idx].tagName),
                                     Provider.of<MultiTapped>(context, listen: false).tapped(),
                                   },
                                   if (widget.callNumber == 2) {
                                     Provider.of<MultiTapped>(context, listen: false).tapped1(),
                                     Provider.of<TagBookProvider>(context, listen: false).setTagID2(tags[idx].tagID),
                                     Provider.of<TagBookProvider>(context, listen: false).changeImage2(tags[idx].iconImage),
                                     Provider.of<TagBookProvider>(context, listen: false).changeTitle2(tags[idx].tagName),
                                   },
                                   if (widget.callNumber == 3) {
                                     Provider.of<MultiTapped>(context, listen: false).tapped2(),
                                     Provider.of<TagBookProvider>(context, listen: false).setTagID3(tags[idx].tagID),
                                     Provider.of<TagBookProvider>(context, listen: false).changeImage3(tags[idx].iconImage),
                                     Provider.of<TagBookProvider>(context, listen: false).changeTitle3(tags[idx].tagName),
                                   }
                                 };
                              }
                            }
                          },
                          child: ListTile(
                            leading: Container(
                              width: widget.screenHeight * 0.05,
                              decoration: BoxDecoration(color: Colors.white,shape: BoxShape.circle,border: Border.all(color: Colors.grey.shade300)),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SvgPicture.network(tags[idx].iconImage),
                              ),
                            ),
                            title: Text(
                              tags[idx].tagName,
                              style: textStyle(
                                widget.screenHeight * 0.019,
                                FontWeight.bold,
                                Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SpacedBox(),
                      ],
                    ), separatorBuilder: (BuildContext context, int index) { return  const Divider(
                    thickness: 0.5,
                  );  },
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
    required this.message, required this.image1, required this.image2, required this.image3, required this.dateCreated,
  });
  final TextEditingController controller;
  final String url;
  final Widget message;
  final String dateCreated;
  final String image1;
  final String image2;
  final String image3;
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.sizeOf(context).height;
    var screenWidth = MediaQuery.sizeOf(context).width;
    return Padding(padding: EdgeInsets.symmetric(vertical: screenHeight * 0.006, horizontal: screenWidth * 0.06),
      child: Container(
        margin: EdgeInsets.only(top: screenHeight * 0.015),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              url.isNotEmpty?Container(
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
              ): const SizedBox(),
              const SpacedBox(),
              Text(
                url,
                style: textStyle(
                    screenHeight * 0.017, FontWeight.bold, Colors.blue),
              ),
              const SpacedBox(),
              message,
              /*Text(
                message,
                style: textStyle(
                    screenHeight * 0.017, FontWeight.w500, Colors.black),
              ),*/
              const SpacedBox(),
              Divider(
                color: Colors.grey.shade300,
              ),
              Row(
                children: [
                  SizedBox(
                    height: screenHeight*0.02,
                    child:  image1.isNotEmpty?SvgPicture.network(image1):null,
                  ),
                  SizedBox(
                    height: screenHeight*0.02,
                    child:  image2.isNotEmpty?SvgPicture.network(image2):null,
                  ),
                  SizedBox(
                    height: screenHeight*0.02,
                    child:  image3.isNotEmpty?SvgPicture.network(image3):null,
                  ),
                  const Spacer(),
                  Text(
                    dateCreated.substring(0,10),
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
