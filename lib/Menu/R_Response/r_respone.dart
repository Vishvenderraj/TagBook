import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../common/styles/styles.dart';
import '../../common/widgets/custom_fields_and_button.dart';


class RResponse extends StatelessWidget {
  const RResponse({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: SafeArea(child: Padding( padding: EdgeInsets.only(
        top: screenHeight * 0.03,
        left: screenWidth * 0.08,
        right: screenWidth * 0.08,
      ),child:
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'R&Responses',
                      style: TextStyle(fontSize:screenHeight*0.037,
                        fontWeight:FontWeight.bold,
                        color: Colors.black,
                        height: 0,),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: screenHeight*0.005),
                      child: Text('we are trying our best',
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
            const SpacedBoxLarge(),
            const RResponseMenu(date: '20-10-24', status: 'In Queue', number: '1', color: Colors.blue,),
            Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight*0.018),
              child: const RResponseMenu(date: '20-10-24', status: 'Suspended', number: '2', color: Colors.red,),
            ),
            const RResponseMenu(date: '20-10-24', status: 'Done', number: '3', color: Colors.green,),
            const SpacedBox(),
            Text('We are working through the queue as quickly as possible',style: textStyle(screenHeight*0.016,
                FontWeight.w400, Colors.grey.shade500),),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.1,vertical: screenHeight*0.04),
              child: Text('Request prompts will auto delete in next 30 days after status update',
                textAlign: TextAlign.center,
                style: textStyle(screenHeight*0.016,
                  FontWeight.w700, Colors.grey.shade400),),
            ),
          ],
        ),),),
    );
  }
}

class RResponseMenu extends StatefulWidget {
  const RResponseMenu({super.key, required this.date, required this.status, required this.number, required this.color});
final String date;
final String status;
final String number;
final Color color;
  @override
  State<RResponseMenu> createState() => _RResponseMenuState();
}

class _RResponseMenuState extends State<RResponseMenu> {
  bool pressed = false;
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;
    return GestureDetector(
      onTap: (){
        setState(() {
          pressed =!pressed;
        });
      },
      child: Material(
        elevation: pressed?5:0,
        shadowColor: Colors.black,
        borderRadius: BorderRadius.only(topLeft: const Radius.circular(30),topRight: const Radius.circular(30),bottomLeft: Radius.circular(pressed?20:30),bottomRight: Radius.circular(pressed?20:30)),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      height: 40,width: 40 ,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          shape: BoxShape.circle
                      ),
                      child: Center(child: Text(widget.number,style: textStyle(screenHeight*0.032, FontWeight.w900, Colors.black),)),
                    ),
                    title: Row(
                      children: [
                        Text(
                          widget.date,
                          style: textStyle(screenHeight*0.017, FontWeight.w400, Colors.black),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.02,vertical: screenHeight*0.01),
                          child: const Text('|'),
                        ),
                        RichText(text: TextSpan(
                            style: textStyle(screenHeight*0.015, FontWeight.w400, Colors.black),
                            children: [
                              const TextSpan(
                                  text: 'Status: '
                              ),
                              TextSpan(
                                text: widget.status,style: textStyle(screenHeight*0.016, FontWeight.w700, widget.color
                              ),)
                            ]
                        ))
                      ],
                    ),
                    trailing: Icon(
                      pressed?CupertinoIcons.chevron_down:Icons.arrow_forward_ios,
                      color: Colors.grey.shade500,
                      size: 20,
                    ),
                  ),

                ],
              ),
            ),
            pressed? SizedBox(
              child: Padding(
                padding: EdgeInsets.only(left: screenWidth*0.06,top: screenHeight*0.02,right: screenWidth*0.06),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('please create an icon for the category of badminton for me.',
                      style: textStyle(screenHeight*0.016, FontWeight.w400, Colors.black),),
                    const SpacedBox(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(style: TextButton.styleFrom(
                          surfaceTintColor: CupertinoColors.white,
                          padding: EdgeInsets.zero,
                          foregroundColor: CupertinoColors.white,

                        ),onPressed: (){},child: Text('view uploaded image',
                          style: textStyle(screenHeight*0.016, FontWeight.w400, Colors.blue),),),
                        TextButton(style:TextButton.styleFrom(
                          surfaceTintColor: CupertinoColors.white,
                          padding: EdgeInsets.zero,
                          foregroundColor: CupertinoColors.white,
                        ),onPressed: (){
                          showModalBottomSheet(context: context, builder: (BuildContext context){
                            return Container(
                              decoration: const BoxDecoration(
                                color: CupertinoColors.white,
                                borderRadius:BorderRadius.only(topRight: Radius.circular(30),
                                topLeft: Radius.circular(30),),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: screenHeight*0.04,
                                horizontal: screenWidth*0.08),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '3 | R&Responses',
                                              style: TextStyle(fontSize:screenHeight*0.037,
                                                fontWeight:FontWeight.bold,
                                                color: Colors.black,
                                                height: 0,),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(vertical: screenHeight*0.005,),
                                              child: Text('we have processed your request',
                                                softWrap: true,
                                                style: textStyle(screenHeight*0.017, FontWeight.w600, Colors.grey),),
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
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: screenHeight*0.02),
                                      child: Container(
                                        height: screenHeight*0.2,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                                            color: Colors.white,
                                            border: Border.all(color: Colors.grey.shade300)
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 5),
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
                                    ),
                                    ContButton(func: (){}, txt: 'close', bgColor: Colors.black, txtColor: Colors.white, showLoader: false,),
                                    const SpacedBox(),
                                    Text('delete request card',style: textStyle(screenHeight*0.016, FontWeight.w600, Colors.grey.shade500),)
                                  ],
                                ),
                              ),
                            );
                          },);
                        }, child: Text('view response',
                          style: textStyle(screenHeight*0.016, FontWeight.w700, Colors.green),),),
                      ],
                    )
                  ],
                ),
              ),
            ):const SizedBox(),
          ],
        ),
      ),
    );
  }
}
