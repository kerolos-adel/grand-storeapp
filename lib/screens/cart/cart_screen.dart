import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grand_store_app/consts/firebase_const.dart';
import 'package:grand_store_app/models/order_model.dart';
import 'package:grand_store_app/provider/orders_provider.dart';
import 'package:grand_store_app/provider/products_provider.dart';
import 'package:grand_store_app/screens/cart/cart_widegt.dart';
import 'package:grand_store_app/widets/empty_screen_widget.dart';
import 'package:grand_store_app/sevices/utlis.dart';
import 'package:grand_store_app/widets/text_widget.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../provider/cart_provider.dart';
import '../../sevices/global_methods.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItemsList =
        cartProvider.getCartItems.values.toList().reversed.toList();
    Color color = Utlis(context).color;
    Size size = Utlis(context).screenSize;
    bool isEmpty = true;
    return cartItemsList.isEmpty
        ? const EmptyScreen(
            imgPath: "assets/images/empty.png",
            butText: "Shop Now",
            text: 'Whoops!',
            subtext: 'no items in your cart yet',
          )
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: TextWidget(
                  text: "Cart(${cartItemsList.length})",
                  color: color,
                  textSize: 22,
                  isTitle: true),
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              actions: [
                IconButton(
                    onPressed: () {
                      GlobalMethods.warningDialog(
                          context: context,
                          title: "Empty your cart?",
                          subtitle: "Are you sure?",
                          fct: () async {
                            await cartProvider.clearOnLineCart();
                            cartProvider.clearLocalCart();
                          });
                    },
                    icon: Icon(
                      IconlyBroken.delete,
                      color: color,
                    )),
              ],
            ),
            body: Column(
              children: [
                _checkout(context: context),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItemsList.length,
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider.value(
                          value: cartItemsList[index],
                          child: CartWidget(
                            q: cartItemsList[index].quantity,
                          ));
                    },
                  ),
                )
              ],
            ));
  }

  Widget _checkout({required context}) {
    Color color = Utlis(context).color;
    Size size = Utlis(context).screenSize;
    final cartProvider = Provider.of<CartProvider>(context);
    final productProvider = Provider.of<ProductsProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    double total = 0;
    cartProvider.getCartItems.forEach((key, value) {
      final getCurrProduct = productProvider.findProductById(value.productId);
      total += (getCurrProduct.isOnSale
              ? getCurrProduct.SalePrice
              : getCurrProduct.price) *
          value.quantity;
    });
    return Container(
        width: double.infinity,
        height: size.height * .1,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Material(
                borderRadius: BorderRadius.circular(10),
                color: Colors.green,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () async {
                    User? user = authInstance.currentUser;
                    final cartProvider =
                        Provider.of<CartProvider>(context, listen: false);
                    cartProvider.getCartItems.forEach((key, value) async {
                      final getCurrProduct =
                          productProvider.findProductById(value.productId);

                      try {
                        final orderId = const Uuid().v4();

                        await FirebaseFirestore.instance
                            .collection('orders')
                            .doc(orderId)
                            .set({
                          'orderId': orderId,
                          'userId': user!.uid,
                          'productId': value.productId,
                          'price': (getCurrProduct.isOnSale
                                  ? getCurrProduct.SalePrice
                                  : getCurrProduct.price) *
                              value.quantity,
                          'totalPrice': total,
                          'quantity': value.quantity,
                          'imageUrl': getCurrProduct.imageUrl,
                          'userName': user.displayName,
                          'orderDate': Timestamp.now(),
                        });
                        await cartProvider.clearOnLineCart();
                        cartProvider.clearLocalCart();
                        orderProvider.fetchOrder();
                        await Fluttertoast.showToast(
                            msg: "your order has been placed",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER);
                      } catch (error) {
                        GlobalMethods.errorDialog(
                            context: context, subtitle: error.toString());
                      } finally {}
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: TextWidget(
                        text: "Order Now", color: Colors.white, textSize: 20),
                  ),
                ),
              ),
              Spacer(),
              TextWidget(
                text: "Totale:\$${total.toStringAsFixed(2)}",
                color: color,
                textSize: 18,
                isTitle: true,
              )
            ],
          ),
        ));
  }
}
