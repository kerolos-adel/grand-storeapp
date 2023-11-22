import 'package:flutter/material.dart';
import 'package:grand_store_app/widets/text_widget.dart';

import '../sevices/utlis.dart';

Widget bottomWidget({required context,required String text,required Function function}) {
  Size size = Utlis(context).screenSize;
  return  Container(
    child: Row(
      children: [
        Material(
          borderRadius: BorderRadius.circular(10),
          color: Colors.green,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              print("addedd");
             function;
            },
            child: Padding(
              padding: EdgeInsets.all(10),
              child: TextWidget(
                  text: text, color: Colors.white, textSize: 20),
            ),
          ),
        ),
      ],
    ),
  );
}

