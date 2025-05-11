import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

import '../models/restaurant_table.dart';   // ← nouveau
import '../models/menu_category.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../providers/order_provider.dart';
import '../widgets/order_total_bar.dart';

class ProductListScreen extends StatelessWidget {
  final RestaurantTable table;              // ← remplacé
  final MenuCategory category;

  const ProductListScreen({
    super.key,
    required this.table,
    required this.category,
  });

  /* ───────────────────────────────────────────────
     Boîte de dialogue : ajouter un produit
  ─────────────────────────────────────────────── */
  Future<void> _addProductDialog(BuildContext context) async {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    IconData? pickedIcon;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Ajouter à « ${category.name} »'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Nom'),
            ),
            TextField(
              controller: priceCtrl,
              decoration: const InputDecoration(labelText: 'Prix (€)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.image_search),
              label: const Text('Choisir une icône'),
              onPressed: () async {
                pickedIcon = await showIconPicker(
                context,
                iconPackModes: [IconPack.material],
              );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Annuler'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Ajouter'),
            onPressed: () {
              final name = nameCtrl.text;
              final price = double.tryParse(priceCtrl.text) ?? 0;
              if (name.isNotEmpty && price > 0 && pickedIcon != null) {
                context
                    .read<ProductProvider>()
                    .add(category.id, name, price, pickedIcon!);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  /* ───────────────────────────────────────────── */

  @override
  Widget build(BuildContext context) {
    final prodProv = context.watch<ProductProvider>();
    final products = prodProv.ofCategory(category.id);
    final orderProv = context.read<OrderProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('${table.name} · ${category.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _addProductDialog(context),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemCount: products.length,
        itemBuilder: (_, i) {
          final p = products[i];

          return GestureDetector(
            onLongPress: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Supprimer'),
                  content: Text('Supprimer « ${p.name} » ?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Non')),
                    ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Oui')),
                  ],
                ),
              );
              if (confirm ?? false) {
                context.read<ProductProvider>().delete(category.id, p);
              }
            },
            onTap: () => orderProv.addProduct(table.id, p),
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(p.icon, size: 42),
                  const SizedBox(height: 8),
                  Text(p.name, textAlign: TextAlign.center),
                  Text('${p.price.toStringAsFixed(2)} €',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: OrderTotalBar(table: table),
    );
  }
}