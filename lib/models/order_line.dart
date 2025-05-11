import 'product.dart';

class OrderLine {
  final Product product;
  int qty;

  OrderLine({required this.product, this.qty = 1});

  double get total => product.price * qty;
}