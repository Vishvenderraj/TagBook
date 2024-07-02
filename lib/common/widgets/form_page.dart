import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../styles/styles.dart';
import 'custom_fields_and_button.dart';

class FeedBack extends StatelessWidget {
  const FeedBack({super.key, required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    int flag = 1;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: CupertinoColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: screenHeight * 0.03,
            left: screenWidth * 0.08,
            right: screenWidth * 0.08,
          ),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(fontSize:screenHeight*0.037,
                              fontWeight:FontWeight.bold,
                              color: Colors.black,
                              height: 0,),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: screenHeight*0.005),
                            child: Text(subtitle,
                              softWrap: true,
                              style: textStyle(screenHeight*0.017, FontWeight.w500, Colors.grey),),
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
                          child:  CircleAvatar(
                            radius: screenHeight*0.029,
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
                ],
              ),
              const SpacedBoxLarge(),
              Container(
                height: screenHeight*0.4,
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
              const SpacedBox(),
              Text('Upload Image',style: textStyle(screenHeight*0.0225, FontWeight.w400, Colors.black),),
              const SpacedBox(),
               (flag == 1)?(
                  Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   CircleAvatar(
                     backgroundColor: Colors.transparent,
                     radius: 35,
                     child: DottedBorder(
                       color: Colors.grey.shade400,
                       borderType: BorderType.Circle,
                       radius: const Radius.circular(50),
                       strokeCap: StrokeCap.butt,
                       child: Center(child: SvgPicture.asset('assets/images/download.svg'),),),
                   ),
                   const SpacedBox(),
                   Text('in order to explain your suggestions visually',style: textStyle(screenHeight*0.017, FontWeight.w400, Colors.grey.shade500),),
                 ],
               )):
               Row(
               mainAxisAlignment: MainAxisAlignment.start,
               children: [
                 GestureDetector(
                   onTap: (){
                   },
                   child: Padding(
                     padding: EdgeInsets.only(right: screenWidth*0.05),
                     child: CircleAvatar(
                       radius: 40,
                       backgroundColor: const Color(0xff2F88FF),
                       child: Image.asset('assets/images/uploadedImage.png',fit: BoxFit.scaleDown,color: CupertinoColors.white,width: 30,height: 30,),
                     ),
                   ),
                 ),
                 Expanded(
                   child: Text('uploaded photo will be shared with your feedback under users feedback with other users on website.',
                   style: textStyle(screenHeight*0.017, FontWeight.w400, Colors.grey.shade500),),
                 )
               ],
                             ),
              const SpacedBoxBig(),
              ContButton(func: (){}, txt: 'Submit', bgColor: Colors.black, txtColor: CupertinoColors.white, showLoader: false,)

            ],
          ),
        ),
      ),
    );
  }
}
