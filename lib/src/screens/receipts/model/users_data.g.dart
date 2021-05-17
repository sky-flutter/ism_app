// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UsersDataAdapter extends TypeAdapter<UsersData> {
  @override
  final int typeId = 0;

  @override
  UsersData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UsersData(
      page: fields[0] as int,
      perPage: fields[1] as int,
      total: fields[2] as int,
      totalPages: fields[3] as int,
      listData: (fields[4] as List)?.cast<UserItemData>(),
      support: fields[5] as Support,
    );
  }

  @override
  void write(BinaryWriter writer, UsersData obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.page)
      ..writeByte(1)
      ..write(obj.perPage)
      ..writeByte(2)
      ..write(obj.total)
      ..writeByte(3)
      ..write(obj.totalPages)
      ..writeByte(4)
      ..write(obj.listData)
      ..writeByte(5)
      ..write(obj.support);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsersDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserItemDataAdapter extends TypeAdapter<UserItemData> {
  @override
  final int typeId = 1;

  @override
  UserItemData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserItemData(
      id: fields[0] as int,
      email: fields[3] as String,
      firstName: fields[1] as String,
      lastName: fields[2] as String,
      avatar: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserItemData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.firstName)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.avatar);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserItemDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SupportAdapter extends TypeAdapter<Support> {
  @override
  final int typeId = 2;

  @override
  Support read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Support(
      url: fields[0] as String,
      text: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Support obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.url)
      ..writeByte(1)
      ..write(obj.text);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SupportAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
