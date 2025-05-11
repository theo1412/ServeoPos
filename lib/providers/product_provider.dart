import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  final _uuid = const Uuid();

  // categoryId → liste de produits
  final Map<String, List<Product>> _data = {};

  List<Product> ofCategory(String catId) =>
      List.unmodifiable(_data[catId] ?? []);

  void add(String catId, String name, double price, IconData icon) {
    final list = _data.putIfAbsent(catId, () => []);
    list.add(Product(
      id: _uuid.v4(),
      categoryId: catId,
      name: name,
      price: price,
      icon: icon,
    ));
    notifyListeners();
  }

  void delete(String catId, Product p) {
    _data[catId]?.remove(p);
    notifyListeners();
  }
}