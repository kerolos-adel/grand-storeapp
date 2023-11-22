import 'package:flutter/material.dart';
import 'package:grand_store_app/models/viewed_model.dart';

class ViewedProductProvider with ChangeNotifier {
  Map<String, ViewedProductModel> viewedProductlistItems = {};

  Map<String, ViewedProductModel> get getViewedProductListItems {
    return viewedProductlistItems;
  }

  void addProductToHistory({required String productId}) {
      viewedProductlistItems.putIfAbsent(
          productId,
              () => ViewedProductModel(
              id: DateTime.now().toString(), productId: productId));
    notifyListeners();
  }

  void clearHistory() {
    viewedProductlistItems.clear();
    notifyListeners();
  }
}
