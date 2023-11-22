import 'package:flutter/material.dart';
import 'package:grand_store_app/sevices/utlis.dart';
import 'package:grand_store_app/widets/back_widget.dart';
import 'package:grand_store_app/widets/on_sale_widget.dart';
import 'package:provider/provider.dart';

import '../../consts/conss.dart';
import '../../models/products_models.dart';
import '../../provider/products_provider.dart';
import '../../widets/feed_items_widget.dart';
import '../../widets/text_widget.dart';

class OnSaleScreen extends StatelessWidget {
  static const routeName = "/OnSaleScreen";

  const OnSaleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    List<ProductModel> productOnSale = ProductsProvider.getOnSaleProduct;
    Size size = Utlis(context).screenSize;
    Color color = Utlis(context).color;
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: TextWidget(
              text: 'Sales',
              color: color,
              textSize: 24,
              isTitle: true,
            ),
            centerTitle: true,
            leading: const BackWidget()),
      body: productOnSale.isEmpty
          ? Center(
              child: Text(
                "No products sale yet!,\nStay turned.",
                style: TextStyle(
                    color: color, fontSize: 30, fontWeight: FontWeight.bold),
              ),
            )
          : GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              childAspectRatio: size.width / (size.height * .60),
              children: List.generate(
                  productOnSale.length,
                  (index) => ChangeNotifierProvider.value(
                      value: productOnSale[index],child:const OnSaleWidget())),
            )
    );
  }
}
