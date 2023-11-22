import 'package:flutter/material.dart';
import 'package:grand_store_app/screens/home/feeds_screen.dart';
import 'package:grand_store_app/widets/text_widget.dart';

import '../sevices/utlis.dart';
import 'back_widget.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({Key? key, required this.imgPath, required this.butText, required this.text, required this.subtext}) : super(key: key);

  final String imgPath,text,subtext,butText;

  @override
  Widget build(BuildContext context) {
    Color color = Utlis(context).color;
    Size size = Utlis(context).screenSize;
    final themeState = Utlis(context).getTheme;
    return Scaffold(
      appBar: AppBar(
        leading: const BackWidget(),
        backgroundColor:Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,

      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imgPath,width: double.infinity,height: size.height*.4,),
          const SizedBox(height: 15,),
          Text(text,style: const TextStyle(color: Colors.red,fontWeight: FontWeight.w700,fontSize: 40),),
          const SizedBox(height: 20,),
          TextWidget(text: subtext, color: color, textSize: 20),
          const SizedBox(height: 20,),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: color, backgroundColor: Theme.of(context).colorScheme.secondary, elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                    )),
              ),
              onPressed: () {
                Navigator.pushNamed(context, FeedsScreen.routeName);
              },
              child: TextWidget(
                text: butText,
                color: themeState ? Colors.grey.shade300 : Colors.grey.shade800,
                textSize: 22,
              ))
        ],
      ),
    );
  }
}
