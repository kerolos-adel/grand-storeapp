import 'package:flutter/material.dart';
import 'package:grand_store_app/provider/viewed_product_provider.dart';
import 'package:grand_store_app/screens/user/viewed/viewed_widget.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../../sevices/global_methods.dart';
import '../../../sevices/utlis.dart';
import '../../../widets/back_widget.dart';
import '../../../widets/empty_screen_widget.dart';
import '../../../widets/text_widget.dart';

import '../orders/order_widget.dart';

class ViewedScreen extends StatefulWidget {
  static const routeName = "/ViewedScreen";

  const ViewedScreen({Key? key}) : super(key: key);

  @override
  State<ViewedScreen> createState() => _ViewedScreenState();
}

class _ViewedScreenState extends State<ViewedScreen> {
  bool check = true;

  @override
  Widget build(BuildContext context) {
    final viewedProvider = Provider.of<ViewedProductProvider>(context);
    final viewedList = viewedProvider.getViewedProductListItems.values
        .toList()
        .reversed
        .toList();

    Size size = Utlis(context).screenSize;
    Color color = Utlis(context).color;
    bool isEmpty = true;

    if (viewedList.isEmpty) {
      return const EmptyScreen(
        imgPath: "assets/images/history.jpg",
        butText: "Shop Now",
        text: 'your history is empty',
        subtext: 'no items has been viewed yet',
      );
    } else {
      return Scaffold(
          appBar: AppBar(
            leading: BackWidget(),
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: TextWidget(
                text: "History", color: color, textSize: 22, isTitle: true),
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            actions: [
              IconButton(
                  onPressed: () {
                    GlobalMethods.warningDialog(
                        context: context,
                        title: "Empty your order?",
                        subtitle: "Are you sure?",
                        fct: () {});
                  },
                  icon: Icon(
                    IconlyBroken.delete,
                    color: color,
                  )),
            ],
          ),
          body: ListView.builder(
            itemCount: viewedList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                child: ChangeNotifierProvider.value(
                  value: viewedList[index],
                  child: const ViewedWidget(),
                ),
              );
            },
          ));
    }
  }
}
