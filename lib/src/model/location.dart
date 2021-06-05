import 'package:hive/hive.dart';

part 'location.g.dart';

@HiveType(typeId: 5)
class Location extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String displayName;

  @HiveField(2)
  int id;

  @HiveField(3)
  bool isEdited;
  @HiveField(4)
  bool isSynced;

  String data;

  Location({
    this.name,
    this.displayName,
    this.id,
  }) {
    data = displayName;
  }

  static List<Location> fromJson(List<dynamic> data) {
    return data
        .map((json) => Location(
              id: json['id'],
              name: json['name'].toString(),
              displayName: json['display_name'].toString(),
            ))
        .toList();
  }
}
