import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grand_store_app/models/viewed_model.dart';
import 'package:grand_store_app/widets/plus_minus_widget.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../../consts/firebase_const.dart';
import '../../../provider/cart_provider.dart';
import '../../../provider/products_provider.dart';
import '../../../sevices/global_methods.dart';
import '../../../sevices/utlis.dart';
import '../../../widets/text_widget.dart';

class ViewedWidget extends StatefulWidget {
  const ViewedWidget({Key? key}) : super(key: key);

  @override
  State<ViewedWidget> createState() => _ViewedWidgetState();
}

class _ViewedWidgetState extends State<ViewedWidget> {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);
    final viewedModel = Provider.of<ViewedProductModel>(context);

    final getCurrProduct =
        productProvider.findProductById(viewedModel.productId);
    double usedPrice = getCurrProduct.isOnSale
        ? getCurrProduct.SalePrice
        : getCurrProduct.price;
    final cartProvider = Provider.of<CartProvider>(context);
    bool? isInCart = cartProvider.getCartItems.containsKey(getCurrProduct.id);

    Size size = Utlis(context).screenSize;
    Color color = Utlis(context).color;
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              height: size.width * .25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.network(
                getCurrProduct.imageUrl,
                width: size.width * .2,
                fit: BoxFit.fill,
              ),
            ),
            Column(
              children: [
                TextWidget(
                  text: getCurrProduct.title,
                  color: color,
                  textSize: 20,
                  isTitle: true,
                ),
                TextWidget(
                  text: "\$${usedPrice.toStringAsFixed(2)}",
                  color: color,
                  textSize: 20,
                  isTitle: true,
                )
              ],
            ),
            const Spacer(flex: 5),
            quantatyController(
              onTap: isInCart
                  ? null
                  : ()async {
                      final User? user = authInstance.currentUser;
                      if (user == null) {
                        GlobalMethods.errorDialog(
                            context: context,
                            subtitle: "no user found, please login first");
                        return;
                      }
                      // cartProvider.addProductToCart(
                      //     productId: getCurrProduct.id, quantity: 1);
                     await GlobalMethods.addToCart(
                          context: context,
                          productId: getCurrProduct.id,
                          quantity: 1);
                      await  cartProvider.fetchCart();

              },
              color: Colors.black,
              icon: isInCart ? Icons.check : IconlyBold.plus,
            )
          ],
        ));
  }
}
