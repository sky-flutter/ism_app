import 'package:hive/hive.dart';

part 'users_data.g.dart';

@HiveType(typeId: 0)
class UsersData extends HiveObject {
  @HiveField(0)
  int page;
  @HiveField(1)
  int perPage;
  @HiveField(2)
  int total;
  @HiveField(3)
  int totalPages;
  @HiveField(4)
  List<UserItemData> listData;
  @HiveField(5)
  Support support;

  UsersData(
      {this.page,
      this.perPage,
      this.total,
      this.totalPages,
      this.listData,
      this.support});

  UsersData.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    perPage = json['per_page'];
    total = json['total'];
    totalPages = json['total_pages'];
    if (json['data'] != null) {
      listData = [];
      json['data'].forEach((v) {
        listData.add(new UserItemData.fromJson(v));
      });
    }
    support =
        json['support'] != null ? new Support.fromJson(json['support']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['per_page'] = this.perPage;
    data['total'] = this.total;
    data['total_pages'] = this.totalPages;
    if (this.listData != null) {
      data['data'] = this.listData.map((v) => v.toJson()).toList();
    }
    if (this.support != null) {
      data['support'] = this.support.toJson();
    }
    return data;
  }
}

@HiveType(typeId: 1)
class UserItemData extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  String firstName;
  @HiveField(2)
  String lastName;
  @HiveField(3)
  String email;
  @HiveField(4)
  String avatar;

  UserItemData(
      {this.id, this.email, this.firstName, this.lastName, this.avatar});

  UserItemData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['avatar'] = this.avatar;
    return data;
  }
}

@HiveType(typeId: 2)
class Support extends HiveObject {
  @HiveField(0)
  String url;
  @HiveField(1)
  String text;

  Support({this.url, this.text});

  Support.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['text'] = this.text;
    return data;
  }
}
