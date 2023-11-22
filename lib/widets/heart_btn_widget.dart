import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grand_store_app/consts/firebase_const.dart';
import 'package:grand_store_app/provider/wishlist_providel.dart';
import 'package:grand_store_app/sevices/global_methods.dart';
import 'package:grand_store_app/sevices/utlis.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../provider/products_provider.dart';

class HeartBtn extends StatefulWidget {
  const HeartBtn({Key? key, this.isInWishlist = false, required this.productId})
      : super(key: key);
  final String productId;
  final bool? isInWishlist;

  @override
  State<HeartBtn> createState() => _HeartBtnState();
}

class _HeartBtnState extends State<HeartBtn> {
  bool isLoading=false;
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);
    final getCurrProduct = productProvider.findProductById(widget.productId);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    Color color = Utlis(context).color;
    return GestureDetector(
      onTap: () async{
        try {
          setState(() {
            isLoading=true;
          });
          final User? user = authInstance.currentUser;
          if (user == null) {
            GlobalMethods.errorDialog(
                context: context,
                subtitle: "no user found, please login first");
            return;
          }
          if (widget.isInWishlist == false && widget.isInWishlist != null) {
           await GlobalMethods.addToWishlist(context: context, productId: widget.productId);
          } else {
            wishlistProvider.removeOneItem(
                wishlistId:
                    wishlistProvider.getWishlistItems[getCurrProduct.id]!.id,
                productId: widget.productId);
          }
       await   wishlistProvider.fetchWishlist();

          setState(() {
            isLoading=false;
          });
        } catch (error) {
          // ignore: use_build_context_synchronously
          GlobalMethods.errorDialog(context: context, subtitle: '$error');
        } finally {
          setState(() {
            isLoading=false;
          });
        }
        //wishlistProvider.addRemoveProductToWishlist(productId: productId);
      },
      child: isLoading?const Padding(
        padding: EdgeInsets.all(8.0),
        child: SizedBox(width: 15,height:15,child: CircularProgressIndicator()),
      ): Icon(
        widget.isInWishlist != null && widget.isInWishlist == true
            ? IconlyBold.heart
            : IconlyLight.heart,
        size: 22,
        color:
            widget.isInWishlist != null && widget.isInWishlist == true ? Colors.red : color,
      ),
    );
  }
}
