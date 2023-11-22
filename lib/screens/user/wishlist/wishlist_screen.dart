import 'package:flutter/material.dart';
import 'package:grand_store_app/screens/user/wishlist/wishlist_widget.dart';
import 'package:grand_store_app/widets/back_widget.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../../provider/wishlist_providel.dart';
import '../../../sevices/global_methods.dart';
import '../../../sevices/utlis.dart';
import '../../../widets/empty_screen_widget.dart';
import '../../../widets/text_widget.dart';

class WishListScreen extends StatelessWidget {
  static const routeName = "/WishListScreen";

  const WishListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = Utlis(context).color;
    Size size = Utlis(context).screenSize;
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final wishlistItemsList =
        wishlistProvider.getWishlistItems.values.toList().reversed.toList();
    return wishlistItemsList.isEmpty
        ? const EmptyScreen(
            imgPath: "assets/images/empty.png",
            butText: "add a wish",
            text: 'your wishlist is empty',
            subtext: 'no items has been wishlisted yet',
          )
        : Scaffold(
            appBar: AppBar(
              leading: const BackWidget(),
              centerTitle: true,
              automaticallyImplyLeading: false,
              title: TextWidget(
                  text: "Wishlist(${wishlistItemsList.length})",
                  color: color,
                  textSize: 22,
                  isTitle: true),
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              actions: [
                IconButton(
                    onPressed: () {
                      GlobalMethods.warningDialog(
                          context: context,
                          title: "Empty your wishlist?",
                          subtitle: "Are you sure?",
                          fct: () async{
                          await  wishlistProvider.clearOnLineWishlist();
                          });
                    },
                    icon: Icon(
                      IconlyBroken.delete,
                      color: color,
                    )),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: size.width / (size.height * .55),
                children: List.generate(
                    wishlistItemsList.length,
                    (index) => ChangeNotifierProvider.value(
                        value: wishlistItemsList[index],
                        child: const WishListWidget())),
              ),
            ));
  }
}
