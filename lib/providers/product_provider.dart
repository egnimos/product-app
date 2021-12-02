import 'package:flutter/cupertino.dart';
import 'package:product_app/models/product.dart';

class ProductProvider with ChangeNotifier {
  final List<Product> _products = [];
  DateTime _dateTime = DateTime.now();

  List<Product> get products => _products;

  DateTime get dateTime => _dateTime;

  //addProduct
  void addProduct(Product product) {
    try {
      //get the last index
      product.id = DateTime.now().toString();
      _products.insert(0, product);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  //updateProduct
  void updateProduct(Product product) {
    try {
      //get the index
      var index = _products.indexWhere((prod) => prod.id == product.id);
      _products.removeWhere((prod) => prod.id == product.id);
      _products.insert(index, product);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  //deleteProduct
  void deleteProduct(String id) {
    try {
      _products.removeWhere((prod) => prod.id == id);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void updateDate(selectedDate) {
    _dateTime = selectedDate;
    notifyListeners();
  }
}
