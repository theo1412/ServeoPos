# Caisse Flutter Starter

Petit projet de départ pour une application de gestion de commandes en restaurant
(caisse) multiplateforme.

## Lancer le projet

```bash
flutter pub get
flutter run -d windows   # ou -d macos / -d android / -d ios / -d chrome
```

## Structure rapide

```
lib/
  main.dart               -- point d'entrée
  screens/
    table_screen.dart     -- plan de salle basique
  models/
    table_model.dart
    product.dart
  services/
    printing_service.dart -- appel ESC/POS réseau
```

## Impression réseau

Modifiez `printerIp` dans `PrintingService` pour le rendre fonctionnel :

```dart
final ps = PrintingService(printerIp: '192.168.1.50');
await ps.printSimpleTicket();
```

## À faire

- Écran de commande (liste des produits, catégories)
- Split note / paiement multiple
- Journal inviolable NF525
- Authentification utilisateurs
