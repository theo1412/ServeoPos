import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/restaurant_table.dart';
import '../providers/table_provider.dart';
import 'category_screen.dart';

class TableScreen extends StatelessWidget {
  const TableScreen({super.key});

  Future<void> _addTableDialog(BuildContext context) async {
    final nameCtrl = TextEditingController();
    int capacity = 4;

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nouvelle table'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nom')),
            DropdownButtonFormField<int>(
              value: 4,
              items: [2,4,6,8]
                  .map((c) => DropdownMenuItem(value: c, child: Text('$c couverts')))
                  .toList(),
              onChanged: (v) => capacity = v ?? 4,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context,false), child: const Text('Annuler')),
          TextButton(onPressed: () => Navigator.pop(context,true),  child: const Text('Créer')),
        ],
      ),
    );

    if (ok ?? false) {
      context.read<TableProvider>().add(nameCtrl.text, capacity);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tables = context.watch<TableProvider>().all;

    return Scaffold(
      appBar: AppBar(title: const Text('Plan de salle'), actions: [
        IconButton(icon: const Icon(Icons.logout),
          onPressed: () => Navigator.pop(context)),   // à remplacer par FirebaseAuth.instance.signOut()
      ]),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, mainAxisSpacing: 16, crossAxisSpacing: 16),
        itemCount: tables.length,
        itemBuilder: (_, i) {
          final t = tables[i];
          return GestureDetector(
            onLongPress: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Supprimer ?'),
                  content: Text('Supprimer « ${t.name} » ?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context,false), child: const Text('Non')),
                    ElevatedButton(onPressed: () => Navigator.pop(context,true), child: const Text('Oui')),
                  ],
                ),
              );
              if (confirm ?? false) context.read<TableProvider>().delete(t);
            },
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CategoryScreen(table: t)),
            ),
            child: Card(child: Center(child: Text(t.name))),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTableDialog(context), child: const Icon(Icons.add)),
    );
  }
}