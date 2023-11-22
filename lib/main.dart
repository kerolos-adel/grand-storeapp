// ignore_for_file: equal_keys_in_map

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grand_store_app/consts/theme_data.dart';
import 'package:grand_store_app/provider/cart_provider.dart';
import 'package:grand_store_app/provider/orders_provider.dart';
import 'package:grand_store_app/provider/products_provider.dart';
import 'package:grand_store_app/provider/viewed_product_provider.dart';
import 'package:grand_store_app/provider/wishlist_providel.dart';
import 'package:grand_store_app/screens/categories/cat_detils_screen.dart';
import 'package:grand_store_app/screens/categories/categoties.dart';
import 'package:grand_store_app/screens/home/feeds_screen.dart';
import 'package:grand_store_app/screens/home/on_sale_screen.dart';
import 'package:grand_store_app/provider/dark_theme_provider.dart';
import 'package:grand_store_app/screens/auth/forget_password_screen.dart';
import 'package:grand_store_app/screens/auth/login_screen.dart';
import 'package:grand_store_app/screens/auth/signup_screen.dart';
import 'package:grand_store_app/screens/btm_bar_screen.dart';
import 'package:grand_store_app/inner_screens/products_details_screen.dart';
import 'package:grand_store_app/screens/user/orders/order_screen.dart';
import 'package:grand_store_app/screens/user/viewed/viewed_screen.dart';
import 'package:grand_store_app/screens/user/wishlist/wishlist_screen.dart';
import 'package:provider/provider.dart';

import 'fetch_screen.dart';
import 'firebase_options.dart';
import 'screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyappState();
}

class _MyappState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePref.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
         return  MultiProvider(

              providers: [
                ChangeNotifierProvider(
                  create: (_) {
                    return themeChangeProvider;
                  },
                ),
                ChangeNotifierProvider(
                  create: (_) {
                    return ProductsProvider();
                  },
                ),
                ChangeNotifierProvider(
                  create: (_) {
                    return CartProvider();
                  },
                ),
                ChangeNotifierProvider(
                  create: (_) {
                    return WishlistProvider();
                  },
                ),
                ChangeNotifierProvider(
                  create: (_) {
                    return ViewedProductProvider();
                  },
                ),
                ChangeNotifierProvider(
                  create: (_) {
                    return OrderProvider();
                  },
                )
              ],
              child: Consumer<DarkThemeProvider>(
                builder: (context, themeProvider, child) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'Flutter Demo',
                    theme:
                        Styles.themeData(themeProvider.getDarkTheme, context),
                    home: const LoginScreen(),
                    routes: {
                      OnSaleScreen.routeName: (context) => const OnSaleScreen(),
                      FeedsScreen.routeName: (context) => const FeedsScreen(),
                      ProductsScreen.routeName: (context) =>
                          const ProductsScreen(),
                      WishListScreen.routeName: (context) =>
                          const WishListScreen(),
                      OrderScreen.routeName: (context) => const OrderScreen(),
                      ViewedScreen.routeName: (context) => const ViewedScreen(),
                      RegisterScreen.routeName: (context) =>
                          const RegisterScreen(),
                      LoginScreen.routeName: (context) => const LoginScreen(),
                      ForgetScreen.routeName: (context) => const ForgetScreen(),
                      CategoriesScreen.routeName: (context) =>
                          CategoriesScreen(),
                      CategoryDetailsScreen.routeName: (context) =>
                          const CategoryDetailsScreen(),
                    },
                  );
                },
              ));
        });
  }
}
