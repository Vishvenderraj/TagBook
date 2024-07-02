import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../common/styles/styles.dart';
import '../../../common/widgets/custom_fields_and_button.dart';

class EditTags extends StatelessWidget {
  const EditTags({super.key, required this.addTag});
 final bool addTag;
  @override
  Widget build(BuildContext context) {
    List<TagWidgets> listDate = [
      TagWidgets(image:'assets/images/workout.svg', func: (){ Provider.of<Tapped>(context,listen: false).tapped();},),
      TagWidgets(image:'assets/images/snapchat.svg', func: (){ Provider.of<Tapped>(context,listen: false).tapped();}),
      TagWidgets(image:'assets/images/cooking.svg', func: (){ Provider.of<Tapped>(context,listen: false).tapped();}),
      TagWidgets(image:'assets/images/shopping.svg', func: (){ Provider.of<Tapped>(context,listen: false).tapped();}),
      TagWidgets(image:'assets/images/youtube.svg', func: (){ Provider.of<Tapped>(context,listen: false).tapped();}),
      TagWidgets(image:'assets/images/workout.svg', func: (){ Provider.of<Tapped>(context,listen: false).tapped();})
    ];
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
                       addTag? 'Create a Tag':'Edit Tags',
                        style: TextStyle(
                          fontSize: screenHeight*0.037,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.005),
                        child: Text(addTag?'you can manage tags: from my profile': 'manage your tags',
                            softWrap: true,
                            style: textStyle(screenHeight*0.017, FontWeight.w500, Colors.grey)),
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
                style: textStyle(screenHeight*0.021, FontWeight.w700, Colors.black),
              ),
              const SpacedBox(),
              CustomTextField(
                  text: 'Workout',
                  iconData: null,
                  maxLen: 20,
                  suffixIcon: false,
                  preffixIcon: true,
                  func: (value) {}, controller: null,
                  keyboardType: TextInputType.text, validField: false, onPressed: () {  }, visibility: false,),
              const SpacedBoxBig(),
              Text(
                'Select Icon',
                style: textStyle(screenHeight*0.021, FontWeight.w700, Colors.black),
              ),
              SizedBox(
                width: screenWidth,
                height: screenHeight * 0.1,
                child: ListView.builder(
                  itemCount: listDate.length,
                  padding: const EdgeInsets.symmetric(vertical:15.5),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => listDate[index],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text('Enter Description',style: textStyle(screenHeight*0.022, FontWeight.w700, Colors.black,),),
              ),
              Container(
                height: screenHeight*0.15,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
                  child: TextFormField(
                    expands: true,
                    maxLines: null,
                    cursorColor: Colors.black,
                    cursorWidth: 1,
                    maxLength: 150,
                    style: const TextStyle(color: Colors.black),
                    decoration:  InputDecoration(
                      counterText: '',
                      hintText: 'Please share your feedback',
                      hintStyle: TextStyle(color: Colors.grey.shade300,fontWeight: FontWeight.w400),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent, width: 1.2),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent, width: 1.2),
                      ),
                    ),
                  ),
                ),
              ),
              const SpacedBoxBig(),
              ContButton(func: (){}, txt: addTag?'Create Tag':'Update', bgColor: addTag?Colors.black:Colors.grey.shade800, txtColor: addTag?Colors.white:Colors.grey.shade300, showLoader: false,),
              const SpacedBoxBig(),
              addTag?const SizedBox():Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.red.shade300),
                    borderRadius: BorderRadius.circular(30)
                ),
                child: ContButton(func: (){}, txt: 'Delete', bgColor: Colors.white, txtColor: Colors.red, showLoader: false,),),
              const Spacer(),
              addTag?Text("keep all your important links and texts tagged in one place, ready whenever you need them. ",style: textStyle(screenHeight*0.017, FontWeight.w500, Colors.black),)
                  :const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class TagWidgets extends StatelessWidget {
  const TagWidgets({
    super.key,
    required this.image, required this.func,
  });

  final String image;
  final Function()? func;
  @override
  Widget build(BuildContext context) {
    bool isTapped = Provider.of<Tapped>(context).isTapped;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Padding(
      padding: EdgeInsets.only(right: screenWidth*0.04),
      child: GestureDetector(
        onTap: () {
          Provider.of<Tapped>(context,listen: false).tapped();
        },
        child: Container(
          width: screenWidth * 0.13,
          height: screenHeight*0.13,
          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.008,vertical: screenHeight*0.008),
          decoration: BoxDecoration(
            border: Border.all(color: isTapped?Colors.blue:Colors.grey.shade300),
            shape: BoxShape.circle,
          ),
          child: Material(
            color: Colors.transparent,
            elevation: isTapped?2:0,
            shape: const CircleBorder(),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                shape: BoxShape.circle,
                color: isTapped?Colors.blue:Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth*0.011,vertical: screenHeight*0.011),
                child: SvgPicture.asset(
                  image,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
