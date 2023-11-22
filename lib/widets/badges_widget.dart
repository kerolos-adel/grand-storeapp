import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
class BadgesWidget extends StatelessWidget {
  const BadgesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(
      child: badges.Badge(
        position: badges.BadgePosition.topEnd(top: 0, end: 3),
        badgeAnimation: const badges.BadgeAnimation.slide(
        ),
        showBadge: true,
        badgeStyle: const badges.BadgeStyle(
          //badgeColor: color,
        ),
        badgeContent: const Text(
         "1",
          style: TextStyle(color: Colors.white),
        ),
        child: IconButton(icon: const Icon(Icons.shopping_cart), onPressed: () {}),
      ),
    ),);
  }
}
