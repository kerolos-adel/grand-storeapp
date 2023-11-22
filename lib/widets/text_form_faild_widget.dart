import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


defaultFormField({
  required String hint,
  required String validatorhint,
  required Function(String)? onChanged,
  bool obscuretext = false,
}) {
  return Padding(
    padding: EdgeInsets.all(10),
    child: TextFormField(
      obscureText: obscuretext,
      onChanged: onChanged,
      validator: (value) {
        if (value!.isEmpty) {
          return "${validatorhint}";
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
          hintText: '${hint}',
          hintStyle: TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10)),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10))),
    ),
  );
}
