import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grand_store_app/consts/firebase_const.dart';
import 'package:uuid/uuid.dart';

class GlobalMethods {
  static Future<void> warningDialog({
    required BuildContext context,
    required String title,
    required String subtitle,
    required Function fct,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                FancyShimmerImage(
                  imageUrl:
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQEwWnlPlPS8jebu6k-a2TnK7fHZS7IHSFi9hLV6g2amWszAZBdGqAdwaoctgGeqRZ-RYg&usqp=CAU',
                  boxFit: BoxFit.fill,
                  width: 20,
                  height: 20,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(title)
              ],
            ),
            content: Text(subtitle),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  fct();
                  Navigator.pop(context);
                },
                child: const Text('Ok'),
              ),
            ],
          );
        });
  }

  static Future<void> errorDialog({
    required BuildContext context,
    required String subtitle,

  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                FancyShimmerImage(
                  imageUrl:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQEwWnlPlPS8jebu6k-a2TnK7fHZS7IHSFi9hLV6g2amWszAZBdGqAdwaoctgGeqRZ-RYg&usqp=CAU',
                  boxFit: BoxFit.fill,
                  width: 20,
                  height: 20,
                ),
                const SizedBox(
                  width: 8,
                ),
                const Text("error occured")
              ],
            ),
            content: Text(subtitle),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Ok'),
              ),
            ],
          );
        });
  }

  static Future<void>addToCart(
  {
    required BuildContext context,
  required String productId,
    required int quantity
}
      )async{
    final User?user=authInstance.currentUser;
    final _uid=user!.uid;
    final cartId=const Uuid().v4();
    try{
      FirebaseFirestore.instance.collection('users').doc(_uid).update({
        'userCart':FieldValue.arrayUnion([
          {
            'cartId':cartId,
            'productId':productId,
            'quantity':quantity,
          }
        ])
      });
      await Fluttertoast.showToast(
        msg: "item has been added to your cart",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER
      );
    }catch (error){
      // ignore: use_build_context_synchronously
      errorDialog(context: context, subtitle: error.toString());
    }
  }
  static Future<void>addToWishlist(
      {
        required String productId,
        required BuildContext context,
      }
      )async{
    final User?user=authInstance.currentUser;
    final _uid=user!.uid;
    final wishlistId=const Uuid().v4();
    try{
      FirebaseFirestore.instance.collection('users').doc(_uid).update({
        'userWish':FieldValue.arrayUnion([
          {
            'wishlistId':wishlistId,
            'productId':productId,
          }
        ])
      });
      await Fluttertoast.showToast(
          msg: "item has been added to your wishlist",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER
      );
    }catch (error){
      // ignore: use_build_context_synchronously
      errorDialog(context: context, subtitle: error.toString());
    }
  }
}

