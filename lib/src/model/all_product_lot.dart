import 'package:hive/hive.dart';

part 'all_product_lot.g.dart';

@HiveType(typeId: 3)
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
  @HiveField(6)
  bool isEdited = false;
  @HiveField(7)
  bool isSynced = false;

  AllProductLot(
      {this.name,
      this.product,
      this.productId,
      this.id,
      this.productQty,
      this.quantities});

  static List<AllProductLot> fromJson(List<dynamic> data) {
    return data
        .map((json) => AllProductLot(
              id: json['id'],
              name: json['name'].toString(),
              product: json['product'].toString(),
              productId: json['product_id'],
              quantities: json['quants'] != null
                  ? Quantity.fromJson(json['quants'])
                  : null,
              productQty: json['product_qty'],
            ))
        .toList();
  }
}

@HiveType(typeId: 4)
class Quantity extends HiveObject {
  @HiveField(0)
  String location;
  @HiveField(1)
  int locationId;
  @HiveField(2)
  double quantity;

  Quantity({this.location, this.locationId, this.quantity});

  static List<Quantity> fromJson(List<dynamic> data) {
    return data
        .map((json) => Quantity(
              location: json['location'],
              locationId: json['location_id'],
              quantity: json['quantity'],
            ))
        .toList();
  }
}
