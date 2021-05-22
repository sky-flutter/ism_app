import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 6)
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
  @HiveField(6)
  bool isEdited;
  @HiveField(7)
  bool isSynced;

  Product(
      {this.name,
      this.reference,
      this.category,
      this.id,
      this.uom,
      this.uomId});

  static List<Product> fromJson(List<dynamic> data) {
    return data
        .map((json) => Product(
              id: json['id'],
              name: json['name'].toString(),
              category: json['category'].toString(),
              reference: json['reference'].toString(),
              uom: json['uom'].toString(),
              uomId: json['uom_id'],
            ))
        .toList();
  }
}
