import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/restaurant_table.dart';   // ← nouveau
import '../models/payment_line.dart';
import '../providers/order_provider.dart';
import '../providers/payment_provider.dart';

class PaymentScreen extends StatelessWidget {
  final RestaurantTable table;
  const PaymentScreen({super.key, required this.table});

  @override
  Widget build(BuildContext context) {
    final orderProv = context.watch<OrderProvider>();
    final payProv   = context.watch<PaymentProvider>();

    final total = orderProv.totalFor(table.id);
    final paid  = payProv.paid(table.id);
    final rest  = (total - paid).clamp(0, total).toDouble();

    void add(PayMethod m, double amt) =>
        context.read<PaymentProvider>().add(table.id, amt, m);

    return Scaffold(
      appBar: AppBar(title: Text('Encaisser · ${table.name}')),
      body: Column(
        children: [
          ListTile(title: const Text('Total'), trailing: Text('$total €')),
          ListTile(title: const Text('Payé'),  trailing: Text('$paid €')),
          ListTile(
            title: const Text('Reste'),
            trailing: Text('$rest €',
                style: TextStyle(color: rest==0? Colors.green : Colors.red,
                                 fontWeight: FontWeight.bold)),
          ),
          const Divider(),
          Wrap(
            spacing: 8,
            children: [
              ElevatedButton(onPressed: () => add(PayMethod.cash, 5),  child: const Text('5€ cash')),
              ElevatedButton(onPressed: () => add(PayMethod.cash, 10), child: const Text('10€ cash')),
              ElevatedButton(onPressed: () => add(PayMethod.cb, rest), child: const Text('Tout CB')),
            ],
          ),
          const Divider(),
          Expanded(
            child: ListView(
              children: payProv.lines(table.id).map((l) =>
                ListTile(
                  title: Text(l.method.name.toUpperCase()),
                  trailing: Text('${l.amount.toStringAsFixed(2)} €'),
                )).toList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: rest==0 ? ElevatedButton(
        onPressed: () {
          // todo: impression + reset
          payProv.clear(table.id);
          Navigator.pop(context);
        },
        child: const Text('Clôturer & imprimer'),
      ) : null,
    );
  }
}