import 'package:hive/hive.dart';

class UserModel extends HiveObject {
  String id;
  String displayName;
  String pin;
  String language; // fr, en, ff, ewo, dua, bam
  bool stealthMode;
  String stealthDisguise; // calculator, recipe, weather, calendar
  String safeWord;
  DateTime createdAt;

  UserModel({
    required this.id,
    required this.displayName,
    required this.pin,
    this.language = 'fr',
    this.stealthMode = false,
    this.stealthDisguise = 'calculator',
    this.safeWord = "j'ai besoin de farine",
    required this.createdAt,
  });
}

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 1;

  @override
  UserModel read(BinaryReader reader) {
    final n = reader.readByte();
    final fields = <int, dynamic>{for (var i = 0; i < n; i++) reader.readByte(): reader.read()};
    return UserModel(
      id: fields[0] as String,
      displayName: fields[1] as String,
      pin: fields[2] as String,
      language: fields[3] as String? ?? 'fr',
      stealthMode: fields[4] as bool? ?? false,
      stealthDisguise: fields[5] as String? ?? 'calculator',
      safeWord: fields[6] as String? ?? "j'ai besoin de farine",
      createdAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer..writeByte(8)
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.displayName)
      ..writeByte(2)..write(obj.pin)
      ..writeByte(3)..write(obj.language)
      ..writeByte(4)..write(obj.stealthMode)
      ..writeByte(5)..write(obj.stealthDisguise)
      ..writeByte(6)..write(obj.safeWord)
      ..writeByte(7)..write(obj.createdAt);
  }
}
