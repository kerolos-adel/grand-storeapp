import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grand_store_app/models/wishlist_model.dart';

import '../consts/firebase_const.dart';

class WishlistProvider with ChangeNotifier {
  Map<String, WishlistModel> wishlistItems = {};

  Map<String, WishlistModel> get getWishlistItems {
    return wishlistItems;
  }

  // void addRemoveProductToWishlist({required String productId}) {
  //   if (wishlistItems.containsKey(productId)) {
  //     removeOneItem(productId);
  //   } else {
  //     wishlistItems.putIfAbsent(
  //         productId,
  //         () => WishlistModel(
  //             id: DateTime.now().toString(), productId: productId));
  //   }
  //   notifyListeners();
  // }
  final userCollection=FirebaseFirestore.instance.collection("users");

  Future<void> fetchWishlist() async {
    final User? user = authInstance.currentUser;
    final DocumentSnapshot userDoc =
    await userCollection.doc(user!.uid).get();
    if (userDoc == null) {
      return;
    }
    final length = userDoc.get('userWish').length;
    for (int i = 0; i < length; i++) {
      wishlistItems.putIfAbsent(
          userDoc.get('userWish')[i]['productId'],
              () => WishlistModel(
            id:  userDoc.get('userWish')[i]['wishlistId'],
            productId:  userDoc.get('userWish')[i]['productId'],
          ));
    }
    notifyListeners();
  }
  Future<void> removeOneItem({

    required String wishlistId,
    required String productId,
  })async {
    final User? user = authInstance.currentUser;
    await userCollection.doc(user!.uid).update({
      'userWish':FieldValue.arrayRemove([
        {
          'wishlistId':wishlistId,
          'productId':productId,
        }
      ])
    });
    wishlistItems.remove(productId);
    await fetchWishlist();
    notifyListeners();
  }
  Future<void>clearOnLineWishlist()async{
    final User? user = authInstance.currentUser;
    await userCollection.doc(user!.uid).update({
      'userWish':[],
    });
    wishlistItems.clear();
    notifyListeners();
  }
  void clearLocalWishlist() {
    wishlistItems.clear();
    notifyListeners();
  }
}
