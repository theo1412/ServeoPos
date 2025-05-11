class TableModel {
  final String id;
  final String name;
  final int capacity;
  bool occupied;

  TableModel({
    required this.id,
    required this.name,
    required this.capacity,
    this.occupied = false,
  });
}
