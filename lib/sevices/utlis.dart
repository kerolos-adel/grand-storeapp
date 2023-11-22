import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grand_store_app/provider/dark_theme_provider.dart';
import 'package:provider/provider.dart';

class Utlis{
  BuildContext context;
  Utlis(this.context);
  bool get getTheme=>Provider.of<DarkThemeProvider>(context).getDarkTheme;
  Color get color=>getTheme?Colors.white:Colors.black;
  Size get screenSize=>MediaQuery.of(context).size;
}