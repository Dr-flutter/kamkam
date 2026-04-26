import 'package:hive/hive.dart';

enum AlertLevel { low, moderate, critical }

class AlertLevelAdapter extends TypeAdapter<AlertLevel> {
  @override
  final int typeId = 4;
  @override
  AlertLevel read(BinaryReader reader) => AlertLevel.values[reader.readByte()];
  @override
  void write(BinaryWriter writer, AlertLevel obj) => writer.writeByte(obj.index);
}

class AlertModel extends HiveObject {
  String id;
  AlertLevel level;
  String location;
  String note;
  DateTime createdAt;
  String status; // pending, sent, resolved
  bool sentToMinfef;

  AlertModel({
    required this.id,
    required this.level,
    required this.location,
    required this.note,
    required this.createdAt,
    this.status = 'sent',
    this.sentToMinfef = true,
  });
}

class AlertModelAdapter extends TypeAdapter<AlertModel> {
  @override
  final int typeId = 5;

  @override
  AlertModel read(BinaryReader reader) {
    final n = reader.readByte();
    final f = <int, dynamic>{for (var i = 0; i < n; i++) reader.readByte(): reader.read()};
    return AlertModel(
      id: f[0], level: f[1], location: f[2], note: f[3],
      createdAt: f[4], status: f[5] ?? 'sent', sentToMinfef: f[6] ?? true,
    );
  }

  @override
  void write(BinaryWriter writer, AlertModel obj) {
    writer..writeByte(7)
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.level)
      ..writeByte(2)..write(obj.location)
      ..writeByte(3)..write(obj.note)
      ..writeByte(4)..write(obj.createdAt)
      ..writeByte(5)..write(obj.status)
      ..writeByte(6)..write(obj.sentToMinfef);
  }
}
