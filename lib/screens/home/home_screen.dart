import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:grand_store_app/screens/home/feeds_screen.dart';
import 'package:grand_store_app/screens/home/on_sale_screen.dart';
import 'package:grand_store_app/provider/dark_theme_provider.dart';
import 'package:grand_store_app/sevices/utlis.dart';
import 'package:grand_store_app/widets/feed_items_widget.dart';
import 'package:grand_store_app/widets/on_sale_widget.dart';
import 'package:grand_store_app/widets/price_wiget.dart';
import 'package:grand_store_app/widets/text_widget.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../consts/conss.dart';
import '../../models/products_models.dart';
import '../../provider/products_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    Color color = Utlis(context).color;
    final themeState = Utlis(context).getTheme;
    Size size = Utlis(context).screenSize;
    final productsProvider = Provider.of<ProductsProvider>(context);
    List<ProductModel>allProducts=ProductsProvider.getProducts;
    List<ProductModel>productOnSale=ProductsProvider.getOnSaleProduct;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
              height: size.height * .33,
              width: double.infinity,
              child: Swiper(
                itemBuilder: (context, index) {
                  return Image.asset(
                    Constss.offerImages[index],
                    fit: BoxFit.fill,
                  );
                },
                indicatorLayout: PageIndicatorLayout.COLOR,
                itemCount: Constss.offerImages.length,
                pagination: const SwiperPagination(),
                autoplay: true,
                control: const SwiperControl(),
              )),
          const SizedBox(
            height: 8,
          ),
          TextButton(
              onPressed: () {
                Navigator.pushNamed(context,OnSaleScreen.routeName);
              },
              child: TextWidget(
                  text: "View all", color: Colors.blue, textSize: 20)),
          Row(
            children: [
              RotatedBox(
                quarterTurns: -1,
                child: Row(
                  children: [
                    TextWidget(
                        text: "On sale".toUpperCase(),
                        color: Colors.red,
                        textSize: 22),
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(
                      IconlyLight.discount,
                      color: Colors.red,
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Flexible(
                  child: SizedBox(
                height: size.height * .24,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return ChangeNotifierProvider.value(
                        value: productOnSale[index],child:const OnSaleWidget());
                  },
                  itemCount: productOnSale.length,
                  scrollDirection: Axis.horizontal,
                ),
              ))
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: "Our Product",
                  color: color,
                  textSize: 22,
                  isTitle: true,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, FeedsScreen.routeName);
                     // GlobalMethod.navigatorTo(context: context, routeName: FeedsScreen.routeName);

                    },
                    child: TextWidget(
                        text: "Browse all", color: Colors.blue, textSize: 20)),
              ],
            ),
          ),
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            childAspectRatio: size.width / (size.height * .61),
            children: List.generate(
                allProducts.length<4?
                allProducts.length:
                4, (index) => ChangeNotifierProvider.value(
              value: allProducts[index],
                  child: const FeedsWidget(

            ),
                )),
          )
        ]),
      ),
    );
  }
}
