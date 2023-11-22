import 'package:flutter/material.dart';
import 'package:grand_store_app/widets/back_widget.dart';
import 'package:provider/provider.dart';

import '../../models/products_models.dart';
import '../../provider/products_provider.dart';
import '../../sevices/utlis.dart';
import '../../widets/feed_items_widget.dart';
import '../../widets/text_widget.dart';

class CategoryDetailsScreen extends StatefulWidget {
  const CategoryDetailsScreen({Key? key}) : super(key: key);
  static const routeName = "/CategoryDetailsScreen";

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetailsScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _searchTextFoucasNode = FocusNode();
  List<ProductModel> listProductSearch = [];

  @override
  void dispose() {
    _controller.dispose();
    _searchTextFoucasNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final catName = ModalRoute.of(context)!.settings.arguments as String;
    List<ProductModel> productsByCat = ProductsProvider.findByCategory(catName);
    Size size = Utlis(context).screenSize;
    Color color = Utlis(context).color;
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: TextWidget(
              text: catName,
              color: color,
              textSize: 24,
              isTitle: true,
            ),
            centerTitle: true,
            leading: const BackWidget()),
        body: productsByCat.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/empty.png"),
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      "No products yet!,\nStay turned.",
                      style: TextStyle(
                          color: color,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
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
                            childAspectRatio: size.width / (size.height * .65),
                            children: List.generate(
                                _controller.text.isNotEmpty?listProductSearch.length:
                                productsByCat.length,
                                (index) => ChangeNotifierProvider.value(
                                      value:_controller.text.isNotEmpty?listProductSearch[index]: productsByCat[index],
                                      child: const FeedsWidget(),
                                    )),
                          )
                  ],
                ),
              ));
  }
}
