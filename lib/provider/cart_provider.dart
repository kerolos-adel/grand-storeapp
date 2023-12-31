import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grand_store_app/consts/firebase_const.dart';
import 'package:grand_store_app/models/cart_model.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartModel> cartItems = {};

  Map<String, CartModel> get getCartItems {
    return cartItems;
  }

  void addProductToCart({
    required String productId,
    required int quantity,
  }) {
    cartItems.putIfAbsent(
        productId,
        () => CartModel(
              id: DateTime.now().toString(),
              productId: productId,
              quantity: quantity,
            ));
    notifyListeners();
  }

  void increaseQuantityByOne(String productId) {
    cartItems.update(
        productId,
        (value) => CartModel(
              id: value.id,
              productId: productId,
              quantity: value.quantity + 1,
            ));
    notifyListeners();
  }
  final userCollection=FirebaseFirestore.instance.collection("users");
  Future<void> fetchCart() async {
    final User? user = authInstance.currentUser;
    final DocumentSnapshot userDoc =
        await userCollection.doc(user!.uid).get();
    if (userDoc == null) {
      return;
    }
    final length = userDoc.get('userCart').length ;
    for (int i = 0; i < length; i++) {
      cartItems.putIfAbsent(
          userDoc.get('userCart')[i]['productId'],
          () => CartModel(
                id:  userDoc.get('userCart')[i]['cartId'],
                productId:  userDoc.get('userCart')[i]['productId'],
                quantity:  userDoc.get('userCart')[i]['quantity'],
              ));
    }
    notifyListeners();
  }

  void reduceQuantityByOne(String productId) {
    cartItems.update(
        productId,
        (value) => CartModel(
              id: value.id,
              productId: productId,
              quantity: value.quantity - 1,
            ));
    notifyListeners();
  }

  Future<void> removeOneItem({

  required String productId,
    required String cartId,
    required int quantity
})async {
    final User? user = authInstance.currentUser;
    await userCollection.doc(user!.uid).update({
      'userCart':FieldValue.arrayRemove([
        {
          'cartId':cartId,
          'productId':productId,
          'quantity':quantity,
        }
      ])
    });
    cartItems.remove(productId);
   await fetchCart();
    notifyListeners();
  }
Future<void>clearOnLineCart()async{
  final User? user = authInstance.currentUser;
  await userCollection.doc(user!.uid).update({
    'userCart':[],
  });
  cartItems.clear();
notifyListeners();
}
  void clearLocalCart() {
    cartItems.clear();
    notifyListeners();
  }
}
