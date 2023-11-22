import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grand_store_app/models/products_models.dart';
import 'package:grand_store_app/provider/cart_provider.dart';
import 'package:grand_store_app/widets/price_wiget.dart';
import 'package:grand_store_app/widets/text_widget.dart';
import 'package:provider/provider.dart';

import '../consts/firebase_const.dart';
import '../inner_screens/products_details_screen.dart';
import '../provider/products_provider.dart';
import '../provider/viewed_product_provider.dart';
import '../provider/wishlist_providel.dart';
import '../sevices/global_methods.dart';
import '../sevices/utlis.dart';
import 'heart_btn_widget.dart';

class FeedsWidget extends StatefulWidget {
  const FeedsWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<FeedsWidget> createState() => _FeedsWidgetState();
}

class _FeedsWidgetState extends State<FeedsWidget> {
  final _quantityTextController = TextEditingController();

  @override
  void initState() {
    _quantityTextController.text = '1';
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utlis(context).screenSize;
    Color color = Utlis(context).color;
    final productModel = Provider.of<ProductModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final viewedProvider = Provider.of<ViewedProductProvider>(context);
    bool? isInCart = cartProvider.getCartItems.containsKey(productModel.id);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(productModel.id);

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor,
        child: InkWell(
          onTap: () {
            viewedProvider.addProductToHistory(productId: productModel.id);
            Navigator.pushNamed(context, ProductsScreen.routeName,
                arguments: productModel.id);
          },
          borderRadius: BorderRadius.circular(12),
          child: Column(
            
            children: [
              Expanded(
                flex: 4,
                child: Image.network(
                  productModel.imageUrl,
                  width: size.width * .28,
                  height: size.height * .12,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 3,
                        child: TextWidget(
                          text: productModel.title,
                          color: color,
                          maxLine: 1,
                          textSize: 19,
                          isTitle: true,
                        ),
                      ),
                      Flexible(
                          flex: 1,
                          child: HeartBtn(
                            productId: productModel.id,
                            isInWishlist: isInWishlist,
                          )),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 4,
                          child: PriceWidget(
                              price: productModel.price,
                              salePrice: productModel.SalePrice,
                              textPrice: _quantityTextController.text,
                              isOnSale: productModel.isOnSale),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Flexible(
                            flex: 3,
                            child: Row(
                              children: [
                                FittedBox(
                                  child: TextWidget(
                                    text: productModel.isPiece ? 'Piece' : 'kg',
                                    color: color,
                                    textSize: 20,
                                    isTitle: true,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Flexible(
                                    child: TextFormField(
                                  controller: _quantityTextController,
                                  key: const ValueKey('10'),
                                  style: TextStyle(color: color, fontSize: 18),
                                  keyboardType: TextInputType.number,
                                  maxLines: 1,
                                  enabled: true,
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9.]'))
                                  ],
                                )),
                              ],
                            ))
                      ],
                    )),
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: isInCart
                      ? null
                      : ()async {
                          final User? user = authInstance.currentUser;
                          if (user == null) {
                            GlobalMethods.errorDialog(
                                context: context,
                                subtitle: "no user found, please login first");
                            return;
                          }

                        await  GlobalMethods.addToCart(
                              context: context,
                              productId: productModel.id,
                              quantity:
                                  int.parse(_quantityTextController.text));
                          await  cartProvider.fetchCart();
                        },
                  child: TextWidget(
                    text: isInCart ? 'in cart' : 'Add to Cart',
                    color: color,
                    textSize: 20,
                    maxLine: 1,
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
