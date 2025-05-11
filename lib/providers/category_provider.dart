import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/menu_category.dart';

class CategoryProvider extends ChangeNotifier {
  final _uuid = const Uuid();

  final List<MenuCategory> _categories = [
    MenuCategory(id: 'entree',  name: 'Entrée',  icon: Icons.ramen_dining),
    MenuCategory(id: 'plat',    name: 'Plat',    icon: Icons.lunch_dining),
    MenuCategory(id: 'dessert', name: 'Dessert', icon: Icons.icecream),
    MenuCategory(id: 'boisson', name: 'Boisson', icon: Icons.local_cafe),
  ];

  List<MenuCategory> get all => List.unmodifiable(_categories);

  void add(String name, IconData icon) {
    _categories.add(MenuCategory(id: _uuid.v4(), name: name, icon: icon));
    notifyListeners();
  }

  void delete(MenuCategory c) {
    _categories.remove(c);
    notifyListeners();
  }
}