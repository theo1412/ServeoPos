import 'package:flutter/foundation.dart';

import '../models/payment_line.dart';

class PaymentProvider extends ChangeNotifier {
  final Map<String, List<PaymentLine>> _map = {}; // tableId → lignes de paiement

  List<PaymentLine> lines(String tableId) => _map[tableId] ?? [];

  void add(String tableId, double amt, PayMethod m) {
    if (amt <= 0) return;
    _map.putIfAbsent(tableId, () => []).add(PaymentLine(amt, m));
    notifyListeners();
  }

  double paid(String tableId) =>
      lines(tableId).fold(0.0, (tot, l) => tot + l.amount);

  void clear(String tableId) {
    _map.remove(tableId);
    notifyListeners();
  }
}