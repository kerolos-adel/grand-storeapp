import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grand_store_app/consts/firebase_const.dart';
import 'package:grand_store_app/fetch_screen.dart';
import 'package:grand_store_app/screens/btm_bar_screen.dart';
import 'package:grand_store_app/sevices/global_methods.dart';
import 'package:grand_store_app/widets/text_widget.dart';

class GoogleButt extends StatefulWidget {
  GoogleButt({super.key});

  @override
  State<GoogleButt> createState() => _GoogleButtState();
}

class _GoogleButtState extends State<GoogleButt> {
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: ()async {
        await  signInWithGoogle();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Image.asset(
                'assets/images/google.png',
                width: 40,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            TextWidget(
                text: "Sign in with google", color: Colors.white, textSize: 18)
          ],
        ),
      ),
    );
  }
}
