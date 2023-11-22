import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../../provider/orders_provider.dart';
import '../../../sevices/global_methods.dart';
import '../../../sevices/utlis.dart';
import '../../../widets/back_widget.dart';
import '../../../widets/empty_screen_widget.dart';
import '../../../widets/text_widget.dart';
import 'order_widget.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = "/OrderScreen";

  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = Utlis(context).screenSize;
    Color color = Utlis(context).color;
    final orderProvider = Provider.of<OrderProvider>(context);
    final orderList = orderProvider.getOrders;
   return FutureBuilder(
     future: orderProvider.fetchOrder(),
     builder: (context, snapshot) {

      return orderList.isEmpty
          ? const EmptyScreen(
        imgPath: "assets/images/empty.png",
        butText: "Shop Now",
        text: 'Whoops!',
        subtext: 'no items has been orderd yet',
      )
          : Scaffold(
          appBar: AppBar(
            leading: const BackWidget(),
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: TextWidget(
                text: "Your orders (${orderList.length})",
                color: color,
                textSize: 22,
                isTitle: true),
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,

          ),
          body: ListView.separated(
            separatorBuilder: (context, index) {
              return Divider(
                color: color,
              );
            },
            itemCount: orderList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                child: ChangeNotifierProvider.value(
                    value: orderList[index], child: const OrderWidget()),
              );
            },
          ));

    },);
    }
}
