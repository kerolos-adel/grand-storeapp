import 'package:flutter/material.dart';

textFormField(

    {
      bool obscureText=false,
      Widget? suffixIcon,
  required BuildContext context,
  required TextEditingController controller,
  required TextInputType keyboardType,
  required String validatorhint,
  required String hint,
}){
  return TextFormField(
    obscureText: obscureText,
    controller: controller,
    keyboardType: TextInputType.emailAddress,
    validator: (value) {
      if (value!.isEmpty) {
        return validatorhint;
      } else {
        return null;
      }
    },
    style: const TextStyle(color: Colors.white),
    decoration:  InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white),
      enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white)),
      suffixIcon: suffixIcon,
    ),

  );
}