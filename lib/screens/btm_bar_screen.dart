import 'package:flutter/material.dart';
import 'package:grand_store_app/provider/dark_theme_provider.dart';
import 'package:grand_store_app/screens/cart/cart_screen.dart';
import 'package:grand_store_app/screens/categories/categoties.dart';
import 'package:grand_store_app/screens/home/home_screen.dart';
import 'package:grand_store_app/screens/user/user.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

import '../provider/cart_provider.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _selctedIndex = 0;

  final List<Map<String, dynamic>> _pages = [
    {'page': const HomeScreen(), 'title': 'Home Screen'},
    {'page': CategoriesScreen(), 'title': 'Categories Screen'},
    {'page': const CartScreen(), 'title': 'Cart Screen'},
    {'page': const UserScreen(), 'title': 'User Screen'},
  ];

  void _selectedPage(int index) {
    setState(() {
      _selctedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool _isDark = themeState.getDarkTheme;
    return Scaffold(
      body: _pages[_selctedIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: _isDark ? Theme.of(context).cardColor : Colors.white,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          currentIndex: _selctedIndex,
          //unselectedItemColor: _isDark?Colors.black:Colors.white10,
          //selectedItemColor: _isDark?Colors.lightBlue.shade200:Colors.black87,
          onTap: _selectedPage,
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: Icon(IconlyLight.home),
              label: "Home",
            ),
            const BottomNavigationBarItem(
              icon: Icon(IconlyLight.category),
              label: "Categories",
            ),
            BottomNavigationBarItem(
              icon: Consumer<CartProvider>(builder: (_, myCart, ch) {
                return badges.Badge(
                  position: badges.BadgePosition.topEnd(top: 0, end: 3),
                  badgeAnimation: const badges.BadgeAnimation.slide(),
                  showBadge: true,
                  badgeContent: Text(
                    myCart.getCartItems.length.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  child: IconButton(
                      icon: const Icon(Icons.shopping_cart), onPressed: () {

                  }),
                );
              }),
              label: "Cart",
            ),
            const BottomNavigationBarItem(
              icon: Icon(IconlyLight.user_1),
              label: "User",
            ),
          ]),
    );
  }
}
