import 'package:flutter/material.dart';

class Product {
  final String id;
  final String categoryId;
  String name;
  double price;
  IconData icon;

  Product({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.price,
    required this.icon,
  });
}