import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/restaurant_table.dart';

class TableProvider extends ChangeNotifier {
  final _uuid = const Uuid();

  final List<RestaurantTable> _tables = [
    RestaurantTable(id: 'T1', name: 'Table 1', capacity: 4),
    RestaurantTable(id: 'T2', name: 'Table 2', capacity: 4),
  ];

  List<RestaurantTable> get all => List.unmodifiable(_tables);

  void add(String name, int cap) {
    _tables.add(
        RestaurantTable(id: _uuid.v4(), name: name.isEmpty ? 'Table' : name, capacity: cap));
    notifyListeners();
  }

  void delete(RestaurantTable t) {
    _tables.remove(t);
    notifyListeners();
  }
}