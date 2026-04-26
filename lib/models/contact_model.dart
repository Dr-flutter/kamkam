import 'package:hive/hive.dart';

class ContactModel extends HiveObject {
  String id;
  String name;
  String phone;
  String relation; // soeur, voisine, amie, collègue
  bool isTrusted;

  ContactModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.relation,
    this.isTrusted = true,
  });
}

class ContactModelAdapter extends TypeAdapter<ContactModel> {
  @override
  final int typeId = 2;

  @override
  ContactModel read(BinaryReader reader) {
    final n = reader.readByte();
    final f = <int, dynamic>{for (var i = 0; i < n; i++) reader.readByte(): reader.read()};
    return ContactModel(
      id: f[0], name: f[1], phone: f[2], relation: f[3], isTrusted: f[4] ?? true,
    );
  }

  @override
  void write(BinaryWriter writer, ContactModel obj) {
    writer..writeByte(5)
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.name)
      ..writeByte(2)..write(obj.phone)
      ..writeByte(3)..write(obj.relation)
      ..writeByte(4)..write(obj.isTrusted);
  }
}
