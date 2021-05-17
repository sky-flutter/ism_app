import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class AllProductLot extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String product;
  @HiveField(2)
  int productId;
  @HiveField(3)
  int id;
  @HiveField(4)
  double productQty;
  @HiveField(5)
  List<Quantity> quantities;

  AllProductLot(
      {this.name,
      this.product,
      this.productId,
      this.id,
      this.productQty,
      this.quantities});

  static List<AllProductLot> fromJson(List<Map<String, dynamic>> data) {
    return data
        .map((json) => AllProductLot(
              id: json['id'],
              name: json['name'],
              product: json['product'],
              productId: json['product_id'],
              quantities: Quantity.fromJson(json['quants']),
              productQty: json['product_qty'],
            ))
        .toList();
  }
}

@HiveType(typeId: 1)
class Quantity extends HiveObject{
  @HiveField(0)
  String location;
  @HiveField(1)
  int locationId;
  @HiveField(2)
  double quantity;

  Quantity({this.location, this.locationId, this.quantity});

  static List<Quantity> fromJson(List<Map<String, dynamic>> data) {
    return data
        .map((json) => Quantity(
              location: json['location'],
              locationId: json['location_id'],
              quantity: json['quantity'],
            ))
        .toList();
  }
}
