import 'package:flutter/material.dart';
import 'package:grand_store_app/provider/dark_theme_provider.dart';
import 'package:grand_store_app/screens/categories/categories_widget.dart';
import 'package:grand_store_app/widets/text_widget.dart';
import 'package:provider/provider.dart';

import '../../sevices/utlis.dart';

class CategoriesScreen extends StatefulWidget {
  CategoriesScreen({Key? key}) : super(key: key);
  static const routeName = "/CategoriesScreen";


  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final List<Color> gridColor = [
    const Color(0xff53B175),
    const Color(0xffF8A44C),
    const Color(0xffF7A593),
    const Color(0xffD3B0E0),
    const Color(0xffFDE598),
    const Color(0xffB7DFF5),
  ];

  List<Map<String, dynamic>> catInfo = [
    {
      'imgPath': 'assets/images/cat/fruits.png',
      'catText': 'Fruits',
    },
    {
      'imgPath': 'assets/images/cat/grains.png',
      'catText': 'Grains',
    },
    {
      'imgPath': 'assets/images/cat/herbs.png',
      'catText': 'Herbs',
    },
    {
      'imgPath': 'assets/images/cat/nuts.png',
      'catText': 'Nuts',
    },
    {
      'imgPath': 'assets/images/cat/spices.png',
      'catText': 'Spices',
    },
    {
      'imgPath': 'assets/images/cat/veg.png',
      'catText': 'Vegetables',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final utils = Utlis(context);
    Color color = utils.color;
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TextWidget(
            text: "Categories", color: color, textSize: 24, isTitle: true),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 240 / 250,
        mainAxisSpacing: 18,
        crossAxisSpacing: 12,
        children: List.generate(6, (index) {
          return CategoryWidget(
            catText: catInfo[index]['catText'],
            imgPath: catInfo[index]['imgPath'],
            passedColor:gridColor[index] ,
          );
        }),
      ),
    );
  }
}
