import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:grand_store_app/inner_screens/products_details_screen.dart';
import 'package:grand_store_app/models/wishlist_model.dart';
import 'package:grand_store_app/sevices/utlis.dart';
import 'package:grand_store_app/widets/heart_btn_widget.dart';
import 'package:grand_store_app/widets/text_widget.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../../provider/products_provider.dart';
import '../../../provider/wishlist_providel.dart';

class WishListWidget extends StatelessWidget {
  const WishListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);

    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final wishlistModel = Provider.of<WishlistModel>(context);
    final getCurrProduct =
        productProvider.findProductById(wishlistModel.productId);
    double usedPrice = getCurrProduct.isOnSale
        ? getCurrProduct.SalePrice
        : getCurrProduct.price;
    bool? isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(getCurrProduct.id);

    Size size = Utlis(context).screenSize;
    Color color = Utlis(context).color;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, ProductsScreen.routeName,
              arguments: wishlistModel.productId);
        },
        child: Container(
          height: size.height * .20,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border.all(color: color, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.only(left: 8),
                  height: size.width * .30,
                  child: Image.network(
                    getCurrProduct.imageUrl,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: HeartBtn(
                      productId: getCurrProduct.id,
                      isInWishlist: isInWishlist,
                    )),
                    TextWidget(
                      text: getCurrProduct.title,
                      color: color,
                      textSize: 20,
                      maxLine: 1,
                      isTitle: true,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextWidget(
                      text: "\$${usedPrice.toStringAsFixed(2)}",
                      color: color,
                      textSize: 18,
                      maxLine: 1,
                      isTitle: true,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
