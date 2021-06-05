import 'package:hive/hive.dart';
import 'package:ism_app/imports.dart';

part 'receipt_data.g.dart';

@HiveType(typeId: 7)
class ReceiptData {
  @HiveField(0)
  String name;
  @HiveField(1)
  int locationId;
  @HiveField(2)
  String origin;
  @HiveField(3)
  String date;
  @HiveField(4)
  int id;

  // @HiveField(5)
  // String partnerId;
  @HiveField(6)
  List<Move> move;
  @HiveField(7)
  String type;
  @HiveField(8)
  String location;
  @HiveField(9)
  List<MoveLineIds> moveLineIds;
  @HiveField(10)
  String internalType;
  @HiveField(11)
  bool isEdited;
  @HiveField(12)
  bool isSynced;
  @HiveField(13)
  var partner;
  @HiveField(14)
  var destocationName;

  // @HiveField(10)
  // String partner;

  ReceiptData({
    this.name,
    this.locationId,
    this.origin,
    this.date,
    this.id,
    // this.partnerId,
    this.move,
    this.destocationName,
    this.type,
    this.internalType,
    this.location,
    this.partner,
    this.moveLineIds,
    /*this.partner*/
  });

  static List<ReceiptData> fromJson(List<dynamic> data) {
    return data.map((json) {
      List<MoveLineIds> moveLineIds = [];
      List<Move> move = [];
      if (json['move'] != null) {
        json["move"].forEach((v) {
          move.add(new Move.fromJson(v));
        });
      }
      if (json['move_line_ids'] != null) {
        json['move_line_ids'].forEach((v) {
          moveLineIds.add(new MoveLineIds.fromJson(v));
        });
      }
      return ReceiptData(
        name: json['name'],
        locationId: json['location_id'],
        origin: json['origin'],
        destocationName: json['location_dest_name'],
        date: json['date'],
        id: json['id'],
        // partnerId: json['partner_id'].toString(),
        type: json['type'],
        partner: json['partner'] ?? "",
        internalType: json['internal_type'] ?? "",
        move: move,
        moveLineIds: moveLineIds,
        location: json['location'],
        // partner: json['partner'],
      );
    }).toList();
  }
}

@HiveType(typeId: 8)
class Move {
  @HiveField(0)
  int moveId;
  @HiveField(1)
  double quantityDone;
  @HiveField(2)
  double productUomQty;
  @HiveField(3)
  int productId;

  Move({this.moveId, this.quantityDone, this.productUomQty, this.productId});

  Move.fromJson(json) {
    moveId = json['move_id'];
    quantityDone = json['quantity_done'];
    productUomQty = json['product_uom_qty'];
    productId = json['product_id'];
  }
}

@HiveType(typeId: 9)
class MoveLineIds {
  @HiveField(0)
  String productUom;
  @HiveField(1)
  int productUomId;
  @HiveField(2)
  String lot;
  @HiveField(3)
  String lotId;
  @HiveField(4)
  double quantityDone;
  @HiveField(5)
  double reservedQty;
  @HiveField(6)
  String product;
  @HiveField(7)
  String destination;
  @HiveField(8)
  int productId;
  @HiveField(09)
  bool isEdited;
  @HiveField(10)
  bool isSynced;
  @HiveField(11)
  int locationFromId;
  @HiveField(12)
  String locationFrom;
  @HiveField(13)
  int locationDestId;

  bool isEditMode = false;
  Location fromLocation,toLocation;

  MoveLineIds(
      {this.productUom,
      this.productUomId,
      this.lot,
      this.lotId,
      this.quantityDone,
      this.reservedQty,
      this.product,
      this.destination,
      this.locationDestId,
      this.locationFrom,
      this.locationFromId,
      this.productId});

  MoveLineIds.fromJson(json) {
    productUom = json['product_uom'];
    productUomId = json['product_uom_id'];
    lot = json['lot_number'].toString();
    lotId = json['lot_id'].toString();
    quantityDone = json['quantity_done'];
    reservedQty = json['reserved_qty'];
    product = json['product'];
    destination = json['destination'];
    locationFrom = json['location_from'];
    locationFromId = json['location_from_id'];
    locationDestId = json['location_dest_id'];
    productId = json['product_id'];
  }
}
