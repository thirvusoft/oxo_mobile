// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class itemlistAdapter extends TypeAdapter<itemlist> {
  @override
  final int typeId = 0;

  @override
  itemlist read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return itemlist(
      (fields[0] as List).cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, itemlist obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.item_list);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is itemlistAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
