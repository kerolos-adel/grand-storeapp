import 'package:flutter/material.dart';

Widget quantatyController(
    {required Function? onTap, required Color color, required IconData icon}) {
  return Flexible(
    flex: 2,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            onTap!();
          },
          child: Padding(
              padding: const EdgeInsets.all(6),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              )),
        ),
      ),
    ),
  );
}
