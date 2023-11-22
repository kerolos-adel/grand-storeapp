import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grand_store_app/provider/products_provider.dart';
import 'package:grand_store_app/sevices/utlis.dart';
import 'package:grand_store_app/widets/back_widget.dart';
import 'package:grand_store_app/widets/bottom_widget.dart';
import 'package:grand_store_app/widets/text_widget.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../consts/firebase_const.dart';
import '../models/products_models.dart';
import '../provider/cart_provider.dart';
import '../provider/viewed_product_provider.dart';
import '../provider/wishlist_providel.dart';
import '../sevices/global_methods.dart';
import '../widets/heart_btn_widget.dart';
import '../widets/plus_minus_widget.dart';

class ProductsScreen extends StatefulWidget {
  static const routeName = "/ProductsScreen";

  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final _quantatyTextController = TextEditingController(text: "1");

  @override
  void dispose() {
    _quantatyTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color color = Utlis(context).color;
    Size size = Utlis(context).screenSize;
      final productProvider = Provider.of<ProductsProvider>(context);
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final cartProvider = Provider.of<CartProvider>(context);
    final getCurrProduct = productProvider.findProductById(productId);
    bool? isInCart=cartProvider.getCartItems.containsKey(getCurrProduct.id);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? isInWishlist =
    wishlistProvider.getWishlistItems.containsKey(getCurrProduct.id);
    double usedPrice = getCurrProduct.isOnSale
        ? getCurrProduct.SalePrice
        : getCurrProduct.price;
    double totalPrice = usedPrice * int.parse(_quantatyTextController.text);
    final viewedProvider = Provider.of<ViewedProductProvider>(context);

    return WillPopScope(
      onWillPop: () async{
        //viewedProvider.addProductToHistory(productId: productId);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              viewedProvider.addProductToHistory(productId: productId);
              Navigator.pop(context);
            },
            child: Icon(
              IconlyLight.arrow_left_2,
              color: color,
            ),
          ),
        ),
        body: SingleChildScrollView(

            child: Column(
              children: [
                Container(
                  height: size.height * .30,
                  width: size.width * .45,
                  decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(12)),
                  child: Image.network(
                    getCurrProduct.imageUrl,
                    width: size.width * .21,
                    height: size.height * .12,
                    fit: BoxFit.fill,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Row(
                    children: [
                      TextWidget(
                        text: getCurrProduct.title,
                        color: color,
                        textSize: 22,
                        isTitle: true,
                      ),
                      const Spacer(),
                      HeartBtn(
                        productId: getCurrProduct.id,
                        isInWishlist: isInWishlist,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Row(
                    children: [
                      TextWidget(
                        text: '\$${usedPrice.toStringAsFixed(2)}',
                        color: Colors.green,
                        textSize: 22,
                        isTitle: true,
                      ),
                      TextWidget(
                        text: getCurrProduct.isPiece ? "/piece" : "/kg",
                        color: color,
                        textSize: 14,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Visibility(
                          visible: getCurrProduct.isOnSale ? true : false,
                          child: Text(
                            '\$${getCurrProduct.price.toStringAsFixed(2)}',
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  width: size.width * .3,
                  child: Row(
                    children: [
                      quantatyController(
                          onTap: () {
                            if (_quantatyTextController.text == 1.toString()) {
                              return;
                            } else
                              // ignore: curly_braces_in_flow_control_structures
                              setState(() {
                                _quantatyTextController.text =
                                    (int.parse(_quantatyTextController.text) - 1)
                                        .toString();
                              });
                          },
                          color: Colors.red,
                          icon: CupertinoIcons.minus),
                      Flexible(
                        flex: 1,
                        child: TextField(
                          controller: _quantatyTextController,
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                          decoration: const InputDecoration(
                              focusedBorder:
                              UnderlineInputBorder(borderSide: BorderSide())),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                          ],
                          onChanged: (value) {
                            setState(() {
                              if (value.isEmpty) {
                                _quantatyTextController.text = "1";
                              } else {
                                return;
                              }
                            });
                          },
                        ),
                      ),
                      quantatyController(
                          onTap: () {
                            setState(() {
                              _quantatyTextController.text =
                                  (int.parse(_quantatyTextController.text) + 1)
                                      .toString();
                            });
                          },
                          color: Colors.green,
                          icon: CupertinoIcons.plus),
                    ],
                  ),
                ),
                SizedBox(height: 170,),
                Container(
                  color: Theme.of(context).colorScheme.secondary,
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            TextWidget(
                              text: "Total",
                              color: color,
                              textSize: 22,
                              isTitle: true,
                            ),
                            Row(
                              children: [
                                TextWidget(
                                  text: '\$${totalPrice.toStringAsFixed(2)}/',
                                  color: color,
                                  textSize: 22,
                                  isTitle: true,
                                ),
                                TextWidget(
                                  text: "/${_quantatyTextController.text}kg",
                                  color: color,
                                  textSize: 14,
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 100,
                        ),
                        Container(
                          child: Row(
                            children: [
                              Material(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.green,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap:isInCart?null:
                                        () async{
                                          final User? user = authInstance.currentUser;
                                          if (user == null) {
                                            GlobalMethods.errorDialog(
                                                context: context, subtitle: "no user found, please login first");
                                          return;
                                          }
                                      print("added");
                                      // cartProvider.addProductToCart(
                                      //     productId: getCurrProduct.id,
                                      //     quantity: int.parse(
                                      //       _quantatyTextController.text,
                                      //     ));
                                         await GlobalMethods.addToCart(
                                              context: context,
                                              productId: getCurrProduct.id,
                                              quantity: int.parse(_quantatyTextController.text,));
                                          await  cartProvider.fetchCart();

                                        },
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: TextWidget(
                                        text:isInCart?'in cart' : "add to Cart", color: Colors.white, textSize: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
      ),
    );
  }
}
