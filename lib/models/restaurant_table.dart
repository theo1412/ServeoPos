class RestaurantTable {
  final String id;
  String name;
  int capacity;

  RestaurantTable({
    required this.id,
    required this.name,
    required this.capacity,
  });

  // (facultatif) sérialisation future
  factory RestaurantTable.fromJson(String id, Map<String, dynamic> json) =>
      RestaurantTable(
        id: id,
        name: json['name'] as String,
        capacity: json['capacity'] as int,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'capacity': capacity,
      };
}