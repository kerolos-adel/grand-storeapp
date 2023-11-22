import 'package:flutter/material.dart';
import 'package:grand_store_app/screens/categories/cat_detils_screen.dart';
import 'package:grand_store_app/screens/categories/categoties.dart';
import 'package:grand_store_app/widets/text_widget.dart';
import 'package:provider/provider.dart';

import '../../inner_screens/products_details_screen.dart';
import '../../provider/dark_theme_provider.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    Key? key,
    required this.catText,
    required this.imgPath,
    required this.passedColor,
  }) : super(key: key);

  final String catText, imgPath;
  final Color passedColor;



  @override
  Widget build(BuildContext context) {
    final themState = Provider.of<DarkThemeProvider>(context);
    final Color color = themState.getDarkTheme ? Colors.white : Colors.black;
    double _screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      child: Container(
        height: _screenWidth * .45,
        decoration: BoxDecoration(
          color: passedColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: passedColor.withOpacity(.7), width: 2),
        ),
        child: Column(
          children: [
            Container(
              height: _screenWidth * .3,
              width: _screenWidth * .3,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(imgPath),
                      fit: BoxFit.fill)),
            ),
            TextWidget(
              text: catText,
              color: color,
              textSize: 20,
              isTitle: true,
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, CategoryDetailsScreen.routeName,arguments: catText);

      },
    );
  }
}
