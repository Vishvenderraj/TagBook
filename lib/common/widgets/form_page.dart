import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tag_book/common/widgets/loader_provider.dart';
import 'package:tag_book/common/widgets/sent_feedback_api.dart';
import '../styles/styles.dart';
import 'custom_fields_and_button.dart';

class FeedBack extends StatefulWidget {
  const FeedBack({super.key, required this.title, required this.subtitle, required this.type});
  final String title;
  final String subtitle;
  final String type;
  @override
  State<FeedBack> createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  File? _selectedImage;

  Future _imagePickerGallery() async {
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(
          () {
        returnedImage!=null? _selectedImage = File(returnedImage.path):null;
      },
    );
  }

  Future _imagePickerCamera() async {
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(
          () {
        returnedImage!=null? _selectedImage = File(returnedImage.path):null;
      },
    );
  }

  TextEditingController feedbackTextController = TextEditingController();

  @override
  void dispose() {
    feedbackTextController.dispose();
    super.dispose();
  }
  final List<String?> listOfImages = [];
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                            widget.title,
                            style: TextStyle(fontSize:screenHeight*0.037,
                              fontWeight:FontWeight.bold,
                              color: Colors.black,
                              height: 0,),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: screenHeight*0.005),
                            child: Text(widget.subtitle,
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
                    controller: feedbackTextController,
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
               (_selectedImage == null)?(
                  Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   GestureDetector(
                     onTap:()async{
                       await _imagePickerGallery();
                       _selectedImage!=null?setState((){
                         listOfImages.add(_selectedImage?.path);
                       }):null;
                     },
                     child: CircleAvatar(
                       backgroundColor: Colors.transparent,
                       radius: 35,
                       child: DottedBorder(
                         color: Colors.grey.shade400,
                         borderType: BorderType.Circle,
                         radius: const Radius.circular(50),
                         strokeCap: StrokeCap.butt,
                         child: Center(child: SvgPicture.asset('assets/images/download.svg'),),),
                     ),
                   ),
                   const SpacedBox(),
                   Text('in order to explain your suggestions visually',style: textStyle(screenHeight*0.017, FontWeight.w400, Colors.grey.shade500),),
                 ],
               )):
               Row(
               mainAxisAlignment: MainAxisAlignment.start,
               children: [
                 GestureDetector(
                   onTap:()async{
                     await _imagePickerGallery();
                     _selectedImage!=null?listOfImages.add(_selectedImage?.path):null;
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
              ContButton(func: feedbackTextController.text.isNotEmpty && _selectedImage != null?() async{
                Provider.of<ShowLoader>(context,listen: false).startLoader();
                if(await sentFeedback(widget.type, feedbackTextController.text, listOfImages) && (mounted))
                  {
                    showBottomSheet(context: context, builder: (context)=>Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),
                      ),
                      child: SizedBox(
                        width: screenWidth,
                        height: screenHeight/4,
                        child: Text("UPLOADED",style: textStyle(30, FontWeight.w300, Colors.black),),
                      ),
                    ),
                    );
                  }
                Provider.of<ShowLoader>(context,listen: false).stopLoader();
                feedbackTextController.clear();
                _selectedImage = null;
              }:(){}, txt: 'Submit', bgColor: Colors.black, txtColor: CupertinoColors.white, showLoader: Provider.of<ShowLoader>(context).showLoader,),
            ],
          ),
        ),
      ),
    );
  }
}
