import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Product {
  @HiveField(0)
  String name;
  @HiveField(1)
  String reference;
  @HiveField(2)
  String uom;
  @HiveField(3)
  String category;
  @HiveField(4)
  int uomId;
  @HiveField(5)
  int id;

  Product(
      {this.name,
      this.reference,
      this.category,
      this.id,
      this.uom,
      this.uomId});

  static List<Product> fromJson(List<Map<String, dynamic>> data) {
    return data
        .map((json) => Product(
              id: json['id'],
              name: json['name'],
              category: json['category'],
              reference: json['reference'],
              uom: json['uom'],
              uomId: json['uom_id'],
            ))
        .toList();
  }
}
