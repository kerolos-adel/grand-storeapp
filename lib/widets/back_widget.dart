import 'package:flutter/material.dart';
import 'package:grand_store_app/sevices/utlis.dart';
import 'package:iconly/iconly.dart';

class BackWidget extends StatelessWidget {
  const BackWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = Utlis(context).color;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.pop(context);
      },
      child: Icon(
        IconlyLight.arrow_left_2,
        color: color,
      ),
    );
  }
}
