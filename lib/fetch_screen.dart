import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grand_store_app/consts/firebase_const.dart';
import 'package:grand_store_app/provider/cart_provider.dart';
import 'package:grand_store_app/provider/orders_provider.dart';
import 'package:grand_store_app/provider/products_provider.dart';
import 'package:grand_store_app/provider/wishlist_providel.dart';
import 'package:grand_store_app/screens/btm_bar_screen.dart';
import 'package:provider/provider.dart';

class FetchScreen extends StatefulWidget {
  const FetchScreen({Key? key}) : super(key: key);

  @override
  State<FetchScreen> createState() => _FetchScreenState();
}

class _FetchScreenState extends State<FetchScreen> {
  @override
  void initState() {
    Future.delayed(
      const Duration(microseconds: 5),
      () async {
        final productsProvider =
            Provider.of<ProductsProvider>(context, listen: false);
        final cartProvider = Provider.of<CartProvider>(context, listen: false);
        final wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);
        // final ordersProvider = Provider.of<OrderProvider>(context, listen: false);
        final User? user = authInstance.currentUser;
        if (user == null) {
          await productsProvider.fetchProducts();
          cartProvider.clearLocalCart();
          wishlistProvider.clearLocalWishlist();
         // ordersProvider.clearLoacalOrder();
        } else {
          await productsProvider.fetchProducts();
          await cartProvider.fetchCart();
          await wishlistProvider.fetchWishlist();
        }
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const BottomBarScreen(),
        ));
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Stack(
        children: [
          Center(child: Image.asset('assets/images/loading.png')),
        ],
      ),
    );
  }
}
