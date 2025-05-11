import 'package:flutter/foundation.dart';
import '../models/order_line.dart';
import '../models/product.dart';

class OrderProvider extends ChangeNotifier {
  // tableId  →  liste des lignes
  final Map<String, List<OrderLine>> _orders = {};

  List<OrderLine> linesFor(String tableId) =>
      _orders[tableId] ?? <OrderLine>[];

  void addProduct(String tableId, Product product) {
    final list = _orders.putIfAbsent(tableId, () => []);
    final idx = list.indexWhere((l) => l.product.id == product.id);
    if (idx >= 0) {
      list[idx].qty += 1;
    } else {
      list.add(OrderLine(product: product));
    }
    notifyListeners();
  }

  void changeQty(String tableId, OrderLine line, int delta) {
    final list = _orders[tableId];
    if (list == null) return;
    final idx = list.indexOf(line);
    if (idx == -1) return;
    list[idx].qty += delta;
    if (list[idx].qty <= 0) list.removeAt(idx);
    notifyListeners();
  }

  void deleteLine(String tableId, OrderLine line) {
    _orders[tableId]?.remove(line);
    notifyListeners();
  }

  double totalFor(String tableId) =>
      linesFor(tableId).fold<double>(0, (t, l) => t + l.total);
}