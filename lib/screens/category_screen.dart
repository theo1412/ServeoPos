import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

import '../models/restaurant_table.dart';   // ← nouveau
import '../models/menu_category.dart';
import '../providers/category_provider.dart';
import '../widgets/order_total_bar.dart';
import 'product_list_screen.dart';


class CategoryScreen extends StatelessWidget {
  final RestaurantTable table;              // ← remplacé
  const CategoryScreen({super.key, required this.table});

  /* ───────────────────────────────────────────────
     Boîte de dialogue : créer une nouvelle catégorie
  ─────────────────────────────────────────────── */
  Future<void> _addCategoryDialog(BuildContext context) async {
    final nameCtrl = TextEditingController();
    IconData? pickedIcon;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nouvelle catégorie'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Nom'),
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
              if (nameCtrl.text.isNotEmpty && pickedIcon != null) {
                context
                    .read<CategoryProvider>()
                    .add(nameCtrl.text, pickedIcon!);
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
    final categories = context.watch<CategoryProvider>().all;

    return Scaffold(
      appBar: AppBar(
        title: Text(table.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _addCategoryDialog(context),
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
        itemCount: categories.length,
        itemBuilder: (_, i) {
          final c = categories[i];

          return GestureDetector(
            onLongPress: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Supprimer'),
                  content: Text('Supprimer « ${c.name} » ?'),
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
                context.read<CategoryProvider>().delete(c);
              }
            },
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductListScreen(table: table, category: c),
              ),
            ),
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(c.icon, size: 42),
                  const SizedBox(height: 8),
                  Text(c.name, textAlign: TextAlign.center),
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