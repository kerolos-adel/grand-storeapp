import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grand_store_app/models/cart_model.dart';
import 'package:grand_store_app/provider/products_provider.dart';
import 'package:grand_store_app/sevices/utlis.dart';
import 'package:grand_store_app/widets/heart_btn_widget.dart';
import 'package:grand_store_app/widets/text_widget.dart';
import 'package:provider/provider.dart';

import '../../provider/cart_provider.dart';
import '../../provider/products_provider.dart';
import '../../provider/wishlist_providel.dart';
import '../../widets/plus_minus_widget.dart';
import '../../inner_screens/products_details_screen.dart';

class CartWidget extends StatefulWidget {
  const CartWidget({Key? key, required this.q}) : super(key: key);
  final int q;

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  final _quantityTextController = TextEditingController();

  @override
  void initState() {
    _quantityTextController.text = widget.q.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utlis(context).screenSize;
    Color color = Utlis(context).color;
    final productProvider = Provider.of<ProductsProvider>(context);
    final cartModel = Provider.of<CartModel>(context);
    final getCurrProduct = productProvider.findProductById(cartModel.productId);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(getCurrProduct.id);
    double usedPrice = getCurrProduct.isOnSale
        ? getCurrProduct.SalePrice
        : getCurrProduct.price;
    final cartProvider = Provider.of<CartProvider>(context);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ProductsScreen.routeName,
            arguments: cartModel.productId);
      },
      child: Row(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      height: size.height * .25,
                      width: size.width * .30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12)),
                      child: Image.network(
                        getCurrProduct.imageUrl,
                        width: size.width * .21,
                        height: size.height * .12,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: getCurrProduct.title,
                          color: color,
                          textSize: 20,
                          isTitle: true,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          width: size.width * .3,
                          child: Row(
                            children: [
                              quantatyController(
                                  onTap: () {
                                    setState(() {
                                      if (_quantityTextController.text ==
                                          1.toString()) {
                                        return;
                                      } else {
                                        cartProvider.reduceQuantityByOne(
                                            cartModel.productId);
                                        _quantityTextController.text =
                                            (int.parse(_quantityTextController
                                                        .text) -
                                                    1)
                                                .toString();
                                      }
                                    });
                                  },
                                  color: Colors.red,
                                  icon: CupertinoIcons.minus),
                              Flexible(
                                flex: 1,
                                child: TextField(
                                  controller: _quantityTextController,
                                  keyboardType: TextInputType.number,
                                  maxLines: 1,
                                  decoration: const InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide())),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9]'))
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      if (value.isEmpty) {
                                        _quantityTextController.text = "1";
                                      } else {
                                        return;
                                      }
                                    });
                                  },
                                ),
                              ),
                              quantatyController(
                                  onTap: () {
                                    cartProvider.increaseQuantityByOne(
                                        cartModel.productId);
                                    setState(() {
                                      _quantityTextController.text = (int.parse(
                                                  _quantityTextController
                                                      .text) +
                                              1)
                                          .toString();
                                    });
                                  },
                                  color: Colors.green,
                                  icon: CupertinoIcons.plus),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: ()async {
                             await cartProvider.removeOneItem(
                                  cartId: cartModel.id,
                                  productId: cartModel.productId,
                                  quantity: cartModel.quantity);

                            },
                            child: const Icon(
                              CupertinoIcons.cart_badge_minus,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          HeartBtn(
                            productId: getCurrProduct.id,
                            isInWishlist: isInWishlist,
                          ),
                          TextWidget(
                            text:
                                '\$${(usedPrice * int.parse(_quantityTextController.text)).toStringAsFixed(2)}',
                            color: color,
                            textSize: 18,
                            maxLine: 1,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    )
                  ],
                )),
          )),
        ],
      ),
    );
  }
}
