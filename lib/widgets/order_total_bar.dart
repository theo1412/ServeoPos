import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/restaurant_table.dart';
import '../providers/order_provider.dart';
import '../screens/payment_screen.dart';

class OrderTotalBar extends StatelessWidget {
  final RestaurantTable table;
  const OrderTotalBar({super.key, required this.table});

  @override
  Widget build(BuildContext context) {
    final total = context.watch<OrderProvider>()
        .totalFor(table.id).toStringAsFixed(2);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PaymentScreen(table: table)),
      ),
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('$total €', style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}