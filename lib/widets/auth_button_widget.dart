import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
   const AuthButton(
      {Key? key,
      required this.fct,
      required this.butoonText,
       this.primary=Colors.white38,
      })
      : super(key: key);

  final Function fct;
  final String butoonText;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: primary,
          ),
          onPressed: () {
            fct();
          },
          child: Text(
            butoonText,
            style: TextStyle(color: Colors.white, fontSize: 18),
          )),
    );
  }
}
