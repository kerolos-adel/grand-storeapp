import 'package:flutter/material.dart';
import 'package:grand_store_app/consts/conss.dart';
import 'package:grand_store_app/widets/back_widget.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../models/products_models.dart';
import '../../provider/products_provider.dart';
import '../../sevices/utlis.dart';
import '../../widets/feed_items_widget.dart';
import '../../widets/text_widget.dart';

class FeedsScreen extends StatefulWidget {
  const FeedsScreen({Key? key}) : super(key: key);
  static const routeName = "/FeedsScreen";

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _searchTextFoucasNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _searchTextFoucasNode.dispose();
    super.dispose();
  }
  List<ProductModel> listProductSearch = [];

@override
  void initState() {
  final productsProvider=Provider.of<ProductsProvider>(context, listen:false);
  productsProvider.fetchProducts();
  super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    List<ProductModel>allProducts=ProductsProvider.getProducts;
    Size size = Utlis(context).screenSize;
    Color color = Utlis(context).color;
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: TextWidget(
              text: 'All Product',
              color: color,
              textSize: 24,
              isTitle: true,
            ),
            centerTitle: true,
            leading: const BackWidget()),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: SizedBox(
                  height: kBottomNavigationBarHeight,
                  child: TextField(
                    focusNode: _searchTextFoucasNode,
                    controller: _controller,
                    onChanged: (value) {
                      setState(() {
                        listProductSearch =
                            ProductsProvider.searchQuery(value);
                      });
                    },
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Colors.greenAccent, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Colors.greenAccent, width: 1),
                        ),
                        hintText: "What's in your mind",
                        prefixIcon: const Icon(Icons.search),
                        suffix: IconButton(
                            onPressed: () {
                              _controller.clear();
                              _searchTextFoucasNode.unfocus();

                            },
                            icon: Icon(
                              Icons.close,
                              color: _searchTextFoucasNode.hasFocus
                                  ? Colors.red
                                  : color,
                            ))),
                  ),
                ),
              ),
              _controller.text.isNotEmpty && listProductSearch.isEmpty
                  ? const Text(
                  'no product found, please try another keyword')
                  : GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                childAspectRatio: size.width / (size.height * .61),
                children: List.generate(
                    _controller.text.isNotEmpty?listProductSearch.length:
                    allProducts.length,
                        (index) => ChangeNotifierProvider.value(
                      value:_controller.text.isNotEmpty?listProductSearch[index]: allProducts[index],
                      child: const FeedsWidget(),
                    )),
              )
            ],
          ),
        ));
  }
}
