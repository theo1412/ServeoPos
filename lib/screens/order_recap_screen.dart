import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/table_model.dart';
import '../models/order_line.dart';
import '../providers/order_provider.dart';

class OrderRecapScreen extends StatelessWidget {
  final TableModel table;
  const OrderRecapScreen({super.key, required this.table});

  @override
  Widget build(BuildContext context) {
    final orderProv = context.watch<OrderProvider>();
    final lines = orderProv.linesFor(table.id);

    return Scaffold(
      appBar: AppBar(title: Text('Commande · ${table.name}')),
      body: lines.isEmpty
          ? const Center(child: Text('Aucun article'))
          : ListView.separated(
              itemCount: lines.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final line = lines[i];
                return ListTile(
                  title: Text(line.product.name),
                  subtitle:
                      Text('${line.qty} × ${line.product.price.toStringAsFixed(2)} €'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () =>
                            orderProv.changeQty(table.id, line, -1),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () =>
                            orderProv.changeQty(table.id, line, 1),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () =>
                            orderProv.deleteLine(table.id, line),
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('TOTAL',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(
              '${orderProv.totalFor(table.id).toStringAsFixed(2)} €',
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}