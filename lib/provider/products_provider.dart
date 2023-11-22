import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/products_models.dart';

class ProductsProvider with ChangeNotifier {
  static List<ProductModel> _productsList = [];

  static List<ProductModel> get getProducts {
    return _productsList;
  }

  static List<ProductModel> get getOnSaleProduct {
    return _productsList.where((element) => element.isOnSale).toList();
  }

  Future<void> fetchProducts() async {
    await FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((QuerySnapshot productSnapshot) {
      _productsList = [];
      //_productsList.clear();
      productSnapshot.docs.forEach((element) {
        _productsList.insert(
            0,
            ProductModel(
              id: element.get('id'),
              title: element.get('title'),
              imageUrl: element.get('imageUrl'),
              productCategoryName: element.get('productCategoryName'),
              price: double.parse(element.get('price')),
              SalePrice: element.get('salePrice'),
              isOnSale: element.get('isOnSale'),
              isPiece: element.get('isPiece'),
            ));
      });
    });
    notifyListeners();
  }

  ProductModel findProductById(String productId) {
    return _productsList.firstWhere((element) => element.id == productId);
  }

  static List<ProductModel> findByCategory(String categoryName) {
    List<ProductModel> categoryList = _productsList
        .where((element) => element.productCategoryName
            .toLowerCase()
            .contains(categoryName.toLowerCase()))
        .toList();
    return categoryList;
  }

  static List<ProductModel> searchQuery(String searchText) {
    List<ProductModel> searchList = _productsList
        .where((element) =>
            element.title.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    return searchList;
  }
}
