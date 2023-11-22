import 'package:flutter/material.dart';
import 'package:grand_store_app/widets/text_widget.dart';

import '../sevices/utlis.dart';

class PriceWidget extends StatelessWidget {
  const PriceWidget(
      {Key? key,
      required this.salePrice,
      required this.price,
      required this.textPrice,
      required this.isOnSale})
      : super(key: key);
  final double salePrice, price;
  final String textPrice;
  final bool isOnSale;

  @override
  Widget build(BuildContext context) {
    double userPrice = isOnSale ? salePrice : price;
    final Color color = Utlis(context).color;
    return FittedBox(
      child: Row(
        children: [
          TextWidget(
              text:
                  '\$${(price * int.parse(textPrice)).toStringAsFixed(2)}',
              color: Colors.green,
              textSize: 19),
          const SizedBox(
            width: 5,
          ),
          Visibility(
            visible: isOnSale ? true : false,
            child: Text(
                '\$${(salePrice * int.parse(textPrice)).toStringAsFixed(2)}',
                style: TextStyle(
                    color: color,
                    fontSize: 15,
                    decoration: TextDecoration.lineThrough)),
          )
        ],
      ),
    );
  }
}
