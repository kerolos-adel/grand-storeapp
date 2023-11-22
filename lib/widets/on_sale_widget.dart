import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grand_store_app/sevices/utlis.dart';
import 'package:grand_store_app/widets/heart_btn_widget.dart';
import 'package:grand_store_app/widets/price_wiget.dart';
import 'package:grand_store_app/widets/text_widget.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../consts/firebase_const.dart';
import '../inner_screens/products_details_screen.dart';
import '../models/products_models.dart';
import '../provider/cart_provider.dart';
import '../provider/viewed_product_provider.dart';
import '../provider/wishlist_providel.dart';
import '../sevices/global_methods.dart';

class OnSaleWidget extends StatefulWidget {
  const OnSaleWidget({Key? key}) : super(key: key);

  @override
  State<OnSaleWidget> createState() => _OnSaleWidgetState();
}

class _OnSaleWidgetState extends State<OnSaleWidget> {
  @override
  Widget build(BuildContext context) {
    final productModel = Provider.of<ProductModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final viewedProvider = Provider.of<ViewedProductProvider>(context);
    bool? isInCart = cartProvider.getCartItems.containsKey(productModel.id);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(productModel.id);

    final Color color = Utlis(context).color;
    final them = Utlis(context).getTheme;
    Size size = Utlis(context).screenSize;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Material(
        color: Theme.of(context).cardColor.withOpacity(0.9),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            viewedProvider.addProductToHistory(productId: productModel.id);
            Navigator.pushNamed(context, ProductsScreen.routeName,
                arguments: productModel.id);
          },
          child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          productModel.imageUrl,
                          width: size.width * .22,
                          height: size.height * .12,
                          fit: BoxFit.fill,
                        ),
                        Column(
                          children: [
                            TextWidget(
                              text: productModel.isPiece ? '1piece' : '1KG',
                              color: color,
                              textSize: 22,
                              isTitle: true,
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: isInCart
                                      ? null
                                      : ()async {
                                          final User? user =
                                              authInstance.currentUser;
                                          if (user == null) {
                                            GlobalMethods.errorDialog(
                                                context: context,
                                                subtitle:
                                                    "no user found, please login first");
                                            return;
                                          }
                                          // cartProvider.addProductToCart(
                                          //     productId: productModel.id,
                                          //     quantity: 1
                                          //     );
                                          await GlobalMethods.addToCart(
                                              context: context,
                                              productId: productModel.id,
                                              quantity: 1);
                                        await  cartProvider.fetchCart();
                                        },
                                  child: Icon(
                                    isInCart
                                        ? IconlyBold.bag_2
                                        : IconlyLight.bag_2,
                                    size: 22,
                                    color: isInCart ? Colors.green : color,
                                  ),
                                ),
                                HeartBtn(
                                  productId: productModel.id,
                                  isInWishlist: isInWishlist,
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: PriceWidget(
                        salePrice: productModel.SalePrice,
                        price: productModel.price,
                        textPrice: "1",
                        isOnSale: true),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    flex: 1,
                    child: TextWidget(
                      text: productModel.title,
                      color: color,
                      textSize: 16,
                      isTitle: true,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
