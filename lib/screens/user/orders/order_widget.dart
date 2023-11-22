import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:grand_store_app/inner_screens/products_details_screen.dart';
import 'package:grand_store_app/models/order_model.dart';
import 'package:grand_store_app/provider/products_provider.dart';
import 'package:provider/provider.dart';

import '../../../provider/cart_provider.dart';
import '../../../sevices/utlis.dart';
import '../../../widets/text_widget.dart';


class OrderWidget extends StatefulWidget {
  const OrderWidget({Key? key}) : super(key: key);

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  late String OrderDateToShow;

  @override
  void didChangeDependencies() {
    final orderModel=Provider.of<OrderModel>(context);
var orderDate=orderModel.orderDate.toDate();
    OrderDateToShow='${orderDate.day}/${orderDate.month}/${orderDate.year}';

    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);
    final orderModel=Provider.of<OrderModel>(context);
    final getCurrProduct = productProvider.findProductById(orderModel.productId);

    Size size = Utlis(context).screenSize;
    Color color = Utlis(context).color;

    return ListTile(
      leading:Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
              child: Image.network(
                getCurrProduct.imageUrl,
                width: size.width*.2,
                fit: BoxFit.fill,
              ),
      ),
      subtitle:  Text('Paid: \$${double.parse(orderModel.price).toStringAsFixed(2)}'),
      title: TextWidget(text: "${getCurrProduct.title}  x${orderModel.quatity}", color: color, textSize: 18),
      trailing: TextWidget(text: OrderDateToShow, color: color, textSize: 18),
    );
  }
}
