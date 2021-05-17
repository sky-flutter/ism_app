import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Location extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String displayName;

  @HiveField(2)
  int id;

  Location({this.name, this.displayName, this.id});

  static List<Location> fromJson(List<Map<String, dynamic>> data) {
    return data
        .map((json) => Location(
              id: json['id'],
              name: json['name'],
              displayName: json['display_name'],
            ))
        .toList();
  }
}
